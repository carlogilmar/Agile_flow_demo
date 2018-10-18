defmodule AgileFlowWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "main:*", AgileFlowWeb.MainChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket

  def connect(_params, socket) do
    IO.puts "Conexión..."
    {:ok, socket}
  end

  def id(_socket), do: nil
end
