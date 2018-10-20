defmodule AgileFlowWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "main:*", AgileFlowWeb.MainChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket

  def connect(_params, socket) do
    user_id = UUID.uuid1()
    IO.puts "Nueva Conexión... #{user_id}"
    conn = assign(socket, :user_id, user_id)
    {:ok, conn}
  end

  def id(_socket), do: nil
end
