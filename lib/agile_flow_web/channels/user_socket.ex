defmodule AgileFlowWeb.UserSocket do
  use Phoenix.Socket
  alias AgileFlow.Director

  ## Channels
  channel "main:*", AgileFlowWeb.MainChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket

  def connect(_params, socket) do
    user_id = UUID.uuid1()
    conn = assign(socket, :user_id, user_id)
    {_, attributes} = Director.suscribe()
    attr = Map.put( attributes, "user_id", user_id )
    conn = assign(socket, :user, attr)
    {:ok, conn}
  end

  def id(_socket), do: nil
end
