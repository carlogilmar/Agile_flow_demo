defmodule AgileFlowWeb.MainChannel do
  use Phoenix.Channel

  def join("main::start", _payload, socket) do
    IO.puts "Main Socket is enable!!"
    {:ok, socket}
  end

	# Send broadcast
	# AgileFlowWeb.Endpoint.broadcast "main::start", "main::change_image", %{ msg: "eagle"}

end
