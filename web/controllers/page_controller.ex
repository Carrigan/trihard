defmodule Trihard.PageController do
  use Trihard.Web, :controller

  def index(conn, _params) do
    user = nil
    if conn.assigns.current_user do
      user = Repo.preload conn.assigns.current_user, :workouts
    end
    render conn, "index.html", user: user
  end
end
