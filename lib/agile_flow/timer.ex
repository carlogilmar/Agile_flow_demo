defmodule AgileFlow.SessionGame do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [], [name: __MODULE__])
  end

  def start_game(), do: GenServer.cast( __MODULE__, {:start} )
  def end_game(), do: GenServer.cast( __MODULE__, {:end} )

  def init(_) do
    {:ok, {:counter, 0} }
  end

  defp loop(), do: send self(), :loop

  def handle_info(:loop, state) do
    {_, counter} = state
    :timer.sleep 1000
    loop()
    {:noreply, {:counter, counter+1} }
  end

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
