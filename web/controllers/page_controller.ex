defmodule Trihard.PageController do
  use Trihard.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
