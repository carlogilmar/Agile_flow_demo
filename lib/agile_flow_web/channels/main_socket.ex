defmodule AgileFlowWeb.MainChannel do
  use Phoenix.Channel
  alias AgileFlowWeb.Presence

  def join("main::start", _payload, socket) do
    send(self(), :after_join)
    current_user = socket.assigns["user_id"]
    {:ok, %{user: current_user}, socket}
  end

  def handle_info(:after_join, socket) do
    user = socket.assigns[:user_id]
    {:ok, _} = Presence.track(socket, user, %{ user_id: user })
    presence_list = Presence.list(socket)
    push socket, "presence_state", presence_list
    {:noreply, socket}
  end

  # Send broadcast
  # AgileFlowWeb.Endpoint.broadcast "main::start", "main::change_image", %{ msg: "eagle"}
  # Show toast in main view!
  # AgileFlowWeb.Endpoint.broadcast "main::start", "main::show_toast", %{ msg: "Carlo se ha conectado!"}

end
