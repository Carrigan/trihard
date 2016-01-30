defmodule Trihard.RegistrationController do
  use Trihard.Web, :controller
  alias Trihard.User

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Trihard.Registration.create(changeset, Trihard.Repo) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Your account was created")
        |> put_session(:user_id, user.id)
        |> redirect(to: "/")
      {:error, changeset} ->
        conn
        |> put_flash(:info, "Unable to create account")
        |> render("new.html", changeset: changeset)
    end
  end
end
