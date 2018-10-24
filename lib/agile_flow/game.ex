defmodule AgileFlow.Game do
  use GenServer

  def start_link(), do: GenServer.start_link(__MODULE__, [], [name: __MODULE__])
  def play(), do: GenServer.cast( __MODULE__, {:start} )
  def reset(), do: GenServer.cast( __MODULE__, {:end} )
  defp loop(), do: send self(), :loop

  def init(_), do: {:ok, {:timer, 0, :session_timer, 0} }

  def handle_info(:loop, state) do
    {:timer, current, :session_timer, session_timer} = state
    next_session_timer = get_next_session_timer( current, session_timer, current == session_timer)
    IO.inspect state
    :timer.sleep 1000
    loop()
    {:noreply, {:timer, current+1, :session_timer, next_session_timer}}
  end

  defp get_next_session_timer( current, session_timer, true) do
    IO.puts "Cambioooooooooooo"
    current + 5
  end
  defp get_next_session_timer( _, session_timer, false) do
    session_timer
  end

  def handle_cast( {:start}, state) do
    IO.puts "Iniciando el juego de la vida"
    # Iniciar el session game
    loop()
    {:noreply, state}
  end

  def handle_cast( {:end}, state) do
    IO.puts "Cerrando sesión"
    Process.exit( self() , :kill)
    {:noreply, state}
  end

end
