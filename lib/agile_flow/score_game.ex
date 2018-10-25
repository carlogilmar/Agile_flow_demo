defmodule AgileFlow.ScoreGame do
  use GenServer
  alias AgileFlowWeb.Endpoint
  #Score goal for play all
  @score_goal 25

  def start_link(), do: GenServer.start_link(__MODULE__, [], [name: __MODULE__])
  def init(_), do: {:ok, {:general_score, 0} }

  def assert(), do: GenServer.cast( __MODULE__, {:assert} )
  def fail(), do: GenServer.cast( __MODULE__, {:fail} )

  def handle_cast( {:assert}, state) do
    {_, score} = state
    next_score = score+1
    #IO.puts "Score: #{next_score}"
    play_everything( next_score )
    Endpoint.broadcast "main::start", "main::score", %{ score: next_score}
    {:noreply, {:general_score, next_score} }
  end

  def handle_cast( {:fail}, state) do
    {_, score} = state
    next_score = decrement_score( score )
    #IO.puts "Score: #{next_score}"
    Endpoint.broadcast "main::start", "main::score", %{ score: next_score}
    IO.puts "SCORE:: Silenciando!"
    Endpoint.broadcast "main::start", "main::stop_all", %{ msg: "fallaron" }
    {:noreply, {:general_score, next_score} }
  end

  def decrement_score( 0 ), do: 0
  def decrement_score( score ), do: score-1

  # Cuando lleguen a un score de 7 que se apaguen para que no suenen todos
  def play_everything( 7 ), do: Endpoint.broadcast "main::start", "main::stop_all", %{ msg: "Continuen!!"}
  def play_everything( 14 ), do: Endpoint.broadcast "main::start", "main::stop_all", %{ msg: "Continuen!!"}
  # Meta para que todos estén filosos!!
  def play_everything( @score_goal ), do: Endpoint.broadcast "main::start", "main::play_all", %{ msg: "suenen todos!"}
  def play_everything( _ ), do: :continue
end
