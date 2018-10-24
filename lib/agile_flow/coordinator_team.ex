defmodule AgileFlow.CoordinatorTeam do
  use GenServer

  @teams ["A", "B", "C", "D", "E", "F", "G", "H"]
  def start_link(), do: GenServer.start_link(__MODULE__, [], [name: __MODULE__])
  def choose_team(), do: GenServer.call( __MODULE__, :choose_team)
  def init(_), do: {:ok, { :team, 0 } }

  def handle_call( :choose_team, _, {:team, team_index} ) do
    next_team_index = get_next_team_index( team_index )
    team = Enum.at( @teams, team_index)
    {:reply, team, {:team, next_team_index}}
  end

  def get_next_team_index( 7 ), do: 0
  def get_next_team_index( index ), do: index+1

end
