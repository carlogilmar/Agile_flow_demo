defmodule AgileFlow.SessionGame do
  use GenServer

  @animals ["eagle", "tapir", "insect", "wolf", "tiger", "elephant"]

  def start_link(), do: GenServer.start_link(__MODULE__, [], [name: __MODULE__])
  def play(), do: GenServer.cast( __MODULE__, {:start} )
  def reset(), do: GenServer.cast( __MODULE__, {:end} )
  defp loop(), do: send self(), :loop

  def init(_), do: {:ok, {:timer, 0, :animals, 0, :enable, 0} }

  def handle_info(:loop, state) do
    {_, counter, _, animals_index, _, enable_counter} = state
    { next_enable_counter, current_state } = get_enable_counter( counter, enable_counter, counter == enable_counter )
    animal = get_animal( animals_index )
    IO.puts "Segundo #{counter}, animal #{animal} Estado: #{current_state} #{next_enable_counter}"
    # send broadcast
    { next_timer, next_animal_index} = get_counters( counter, animals_index)
    :timer.sleep 1000
    loop()
    {:noreply, {:timer, next_timer, :animals, next_animal_index, :enable, next_enable_counter} }
  end

  defp get_enable_counter( current, _, true), do: { current + 5, :disable}
  defp get_enable_counter( _, enable_counter, false), do: { enable_counter, :enable }

  defp get_animal( index ), do: Enum.at( @animals, index )
  defp get_counters( counter, 5), do: {counter+1, 0}
  defp get_counters( counter, animals ), do: {counter+1, animals+1}

  def handle_cast( {:start}, state) do
    IO.puts "Empezando el contador"
    loop()
    {:noreply, state}
  end

  def handle_cast( {:end}, state) do
    IO.puts "Deteniendo  el contador"
    Process.exit( self() , :kill)
    {:noreply, state}
  end

end
