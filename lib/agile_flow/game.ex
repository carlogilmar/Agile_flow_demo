defmodule AgileFlow.Game do
  use GenServer

  def start_link(), do: GenServer.start_link(__MODULE__, [], [name: __MODULE__])
  def play(), do: GenServer.cast( __MODULE__, {:start} )
  def reset(), do: GenServer.cast( __MODULE__, {:end} )
  defp loop(), do: send self(), :loop

  def init(_), do: {:ok, {:timer, 0} }

  def handle_info(:loop, state) do
    {:timer, current} = state
    IO.inspect state
    :timer.sleep 1000
    loop()
    {:noreply, {:timer, current+1}}
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
