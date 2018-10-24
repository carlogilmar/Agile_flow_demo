defmodule AgileFlow.Game do
  use GenServer
  alias AgileFlow.CoordinatorTeam

  def start_link(), do: GenServer.start_link(__MODULE__, [], [name: __MODULE__])
  def play(), do: GenServer.cast( __MODULE__, {:start} )
  def reset(), do: GenServer.cast( __MODULE__, {:end} )
  defp loop(), do: send self(), :loop

  def init(_), do: {:ok, {:timer, 0, :session_timer, 0, :current_team, nil} }

  def handle_info(:loop, state) do
    IO.inspect state
    {_, current, _, session_timer, _, current_team} = state
    {next_session_timer, team}  = get_next_session_timer( current_team, current, session_timer, current == session_timer)
    :timer.sleep 1000
    loop()
    {:noreply, {:timer, current+1, :session_timer, next_session_timer, :current_team, team} }
  end

  defp get_next_session_timer( team, _, session_timer, false), do: { session_timer, team}
  defp get_next_session_timer( _, current, session_timer, true) do
    current_team = CoordinatorTeam.choose_team()
    IO.inspect current_team
    { current + 5, current_team }
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
