defmodule AgileFlowWeb.MainChannel do
  use Phoenix.Channel
  alias AgileFlowWeb.Presence
  alias AgileFlow.Director

  def join("main::start", _payload, socket) do
    send(self(), :after_join)
    {:ok, socket.assigns.user, socket}
  end

  def handle_info(:after_join, socket) do
    user = socket.assigns.user
    {:ok, _} = Presence.track(socket, user["user_id"], user)
    presence_list = Presence.list(socket)
    push socket, "presence_state", presence_list
    counters = count_users( socket )
    push socket, "main::team_players", counters
    {:noreply, socket}
  end

  def handle_in("main::sync_users", _payload, socket) do
    counters = count_users( socket )
    push socket, "main::team_players", counters
    {:noreply, socket}
  end

  # Send broadcast
  # AgileFlowWeb.Endpoint.broadcast "main::start", "main::change_image", %{ msg: "eagle"}
  # Show toast in main view!
  # AgileFlowWeb.Endpoint.broadcast "main::start", "main::show_toast", %{ msg: "Carlo se ha conectado!"}

  def count_users( socket ) do
    tracking = Presence.list(socket)
    users = tracking |> Map.keys()
    users_size = users |> Enum.count
    categories =
      for user <- users do
        [meta] = tracking[user].metas
        meta["category"]
      end
    categories |> get_counters() |> fill_empty_keys()
  end

  def get_counters( categories ), do: categories |> Enum.reduce( %{}, fn state, counter -> Map.put( counter, state, (counter[state] || 0) + 1 ) end )

  def fill_empty_keys( counters_map ) do
    counters = %{}
    keys = ["A", "B", "C", "D", "E", "F", "G", "H"]
    [a,b,c,d,e,f,g,h] = for key <- keys, do: counter = get_counter( counters_map[ key ] )
    %{ "A" => a, "B" => b, "C" => c, "D" => d, "E" => e, "F" => f, "G" => g, "H" => h }
  end

  defp get_counter( nil ), do: 0
  defp get_counter( n ), do: n


end
