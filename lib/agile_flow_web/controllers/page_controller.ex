defmodule AgileFlowWeb.PageController do
  use AgileFlowWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def monitor(conn, _params) do
    render conn, "monitor.html"
  end

end
