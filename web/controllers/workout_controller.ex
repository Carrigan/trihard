defmodule Trihard.WorkoutController do
  use Trihard.Web, :controller
  require IEx

  alias Trihard.Workout

  plug :scrub_params, "workout" when action in [:create, :update]

  def index(conn, _params) do
    user = Repo.preload conn.assigns.current_user, :workouts
    render(conn, "index.html", workouts: user.workouts)
  end

  def new(conn, _params) do
    changeset = Workout.changeset(%Workout{ date: Ecto.Date.utc })
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"workout" => workout_params}) do
    changeset = Workout.changeset(
      %Workout{user_id: conn.assigns.current_user.id},
      workout_params)

    case Repo.insert(changeset) do
      {:ok, _workout} ->
        conn
        |> put_flash(:info, "Workout created successfully.")
        |> redirect(to: workout_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    workout = Repo.get!(Workout, id)
    if workout.user_id != conn.assigns.current_user.id do
      conn
      |> put_status(:not_found)
      |> render(Trihard.ErrorView, "404.html")
    end
    render(conn, "show.html", workout: workout)
  end

  def edit(conn, %{"id" => id}) do
    workout = Repo.get!(Workout, id)
    changeset = Workout.changeset(workout)
    render(conn, "edit.html", workout: workout, changeset: changeset)
  end

  def update(conn, %{"id" => id, "workout" => workout_params}) do
    workout = Repo.get!(Workout, id)
    changeset = Workout.changeset(workout, workout_params)

    case Repo.update(changeset) do
      {:ok, workout} ->
        conn
        |> put_flash(:info, "Workout updated successfully.")
        |> redirect(to: workout_path(conn, :show, workout))
      {:error, changeset} ->
        render(conn, "edit.html", workout: workout, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    workout = Repo.get!(Workout, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(workout)

    conn
    |> put_flash(:info, "Workout deleted successfully.")
    |> redirect(to: workout_path(conn, :index))
  end
end
