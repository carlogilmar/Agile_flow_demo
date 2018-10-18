defmodule AgileFlowWeb.MainChannel do
  use Phoenix.Channel

  def join("main::start", _payload, socket) do
    IO.puts "Main Socket is enable!!"
    {:ok, socket}
  end

end
