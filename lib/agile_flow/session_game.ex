defmodule AgileFlow.SessionGame do
  use GenServer

  @animals ["eagle", "tapir", "insect", "wolf", "tiger", "elephant"]

  def start_link(), do: GenServer.start_link(__MODULE__, [], [name: __MODULE__])
  def play(), do: GenServer.cast( __MODULE__, {:start} )
  def reset(), do: GenServer.cast( __MODULE__, {:end} )
  defp loop(), do: send self(), :loop

  def init(_), do: {:ok, {:timer, 0, :animals, 0, :enable_flag, 0, :disable, :no_animal_selected} }

  def handle_info(:loop, state) do
    {_, counter, _, animals_index, _, enable_counter, current, animal} = state
    next_state = get_next_state( counter, animals_index, enable_counter )
    IO.inspect next_state
    :timer.sleep 1000
    loop()
    {:noreply, next_state}
  end

  defp get_next_state( counter, animals_index, enable_counter ) do
    { next_enable_counter, next_current_state } = get_enable_counter( counter, enable_counter, counter == enable_counter)
    { next_animals_index, next_animal } = get_next_animal( animals_index, next_current_state )
    {:timer, counter+1, :animals, next_animals_index, :enable_flag, next_enable_counter, next_current_state, next_animal}
  end

  def get_next_animal( index, :disable) do
    next_index = get_next_animal_index( index )
    next_animal = get_animal( next_index )
    { next_index, next_animal }
  end
  def get_next_animal( index, :enable) do
    animal = get_animal( index )
    { index, animal }
  end

  # Define how many seconds we are going to change the animal
  defp get_enable_counter( current, _, true), do: { current + 5, :disable}
  defp get_enable_counter( _, enable_counter, false), do: { enable_counter, :enable }

  defp get_animal( index ), do: Enum.at( @animals, index )
  defp get_next_animal_index(5), do: 0
  defp get_next_animal_index( index ), do: index+1

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