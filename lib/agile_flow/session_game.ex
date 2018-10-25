defmodule AgileFlow.SessionGame do
  use GenServer
  alias AgileFlowWeb.Endpoint
  alias AgileFlow.ScoreGame
  @animals ["eagle", "tapir", "insect", "wolf", "tiger", "elephant"]
  # Sincronizar SessionGame con Game
  @period_time 6

  def start_link(), do: GenServer.start_link(__MODULE__, [], [name: __MODULE__])
  def play(), do: GenServer.cast( __MODULE__, {:start} )
  def reset(), do: GenServer.cast( __MODULE__, {:end} )
  def validate_answer( answer ), do: GenServer.cast(__MODULE__, {:validate_answer, answer } )
  defp loop(), do: send self(), :loop

  def init(_), do: {:ok, {:timer, 0, :animals, 0, :enable_flag, 0, :disable, :no_animal_selected} }

  def handle_info(:loop, state) do
    {_, counter, _, animals_index, _, enable_counter, _, _} = state
    next_state = get_next_state( counter, animals_index, enable_counter )
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
    IO.puts "Animal: #{next_animal}"
    Endpoint.broadcast "main::start", "main::change_image", %{ msg: next_animal }
    { next_index, next_animal }
  end
  def get_next_animal( index, :enable) do
    animal = get_animal( index )
    { index, animal }
  end

    # Periodo de tiempo en que cambia el animal
  defp get_enable_counter( current, _, true), do: { current + @period_time, :disable}
  defp get_enable_counter( _, enable_counter, false), do: { enable_counter, :enable }

  defp get_animal( index ), do: Enum.at( @animals, index )
  defp get_next_animal_index(5), do: 0
  defp get_next_animal_index( index ), do: index+1

  def handle_cast( {:start}, state) do
    IO.puts "Session Game Starting..."
    loop()
    {:noreply, state}
  end

  def handle_cast( {:end}, state) do
    IO.puts "Session Game Stopped..."
    Process.exit( self() , :kill)
    {:noreply, state}
  end

  def handle_cast( { :validate_answer, {answer, team} }, state) do
    {:timer, _, :animals, _, :enable_flag, _, _, animal_selected} = state
    validate_answer( animal_selected == answer, team )
    IO.puts " Validando Respuesta: #{answer} Animal en curso: #{animal_selected} "
    {:noreply, state}
  end

  def validate_answer( true, team) do
    IO.puts " #{team} lo hizo!, que suene!!"
    AgileFlow.ScoreGame.assert()
    Endpoint.broadcast "main::start", "main::success_toast", %{ msg: "Respuesta Correcta del equipo #{team}!!"}
    Endpoint.broadcast "main::start", "main::play_team", %{ team: team}
  end

  def validate_answer( false, team) do
    IO.puts " #{team} falló!"
    AgileFlow.ScoreGame.fail()
    Endpoint.broadcast "main::start", "main::fail_toast", %{ msg: "Respuesta Incorrecta del equipo #{team}!!"}
  end

end
