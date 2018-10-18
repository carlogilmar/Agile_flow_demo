defmodule AgileFlowWeb.MainChannel do
  use Phoenix.Channel

  def join("main::start", _payload, socket) do
    IO.puts "Main Socket is enable!!"
    {:ok, socket}
  end

	# Send broadcast
	# AgileFlowWeb.Endpoint.broadcast "main::start", "main::change_image", %{ msg: "eagle"}
  # Show toast in main view!
  # AgileFlowWeb.Endpoint.broadcast "main::start", "main::show_toast", %{ msg: "Carlo se ha conectado!"}

end
