defmodule AgileFlow.SessionGame do
  use GenServer

  @animals ["eagle", "tapir", "insect", "wolf", "tiger", "elephant"]

  def start_link() do
    GenServer.start_link(__MODULE__, [], [name: __MODULE__])
  end

  def start_game(), do: GenServer.cast( __MODULE__, {:start} )
  def end_game(), do: GenServer.cast( __MODULE__, {:end} )

  def init(_) do
    {:ok, {:counter, 0, :animals, 0} }
  end

  defp loop(), do: send self(), :loop

  def handle_info(:loop, state) do
    {_, counter, _, animals_index} = state
    IO.puts "Segundo #{counter}, animal #{get_animal( animals_index )}"
    counters = get_counters( counter, animals_index)
    :timer.sleep 1000
    loop()
    {:noreply, counters }
  end
  defp get_animal( index ), do: Enum.at( @animals, index )
  defp get_counters( counter, 5), do: {:counter, counter+1, :animals, 0}
  defp get_counters( counter, animals ), do: {:counter, counter+1, :animals, animals+1}

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
