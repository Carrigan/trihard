defmodule Trihard.WorkoutController do
  use Trihard.Web, :controller
  require IEx

  alias Trihard.Workout

  plug :scrub_params, "workout" when action in [:create, :update]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
      [conn, conn.params, conn.assigns.current_user])
  end

  def user_workouts(user) do
    assoc(user, :workout)
  end

  def index(conn, _params, user) do
    render(conn, "index.html", workouts: user_workouts(user))
  end

  def new(conn, _params, user) do
    changeset = Workout.changeset(%Workout{date: Ecto.Date.utc})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"workout" => workout_params}, user) do
    changeset = user
      |> build_assoc(:workouts)
      |> Workout.changeset(workout_params)

    case Repo.insert(changeset) do
      {:ok, _workout} ->
        conn
        |> put_flash(:info, "Workout created successfully.")
        |> redirect(to: workout_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, user) do
    workout = user |> user_workouts |> Repo.get!(id)
    render(conn, "show.html", workout: workout)
  end

  def edit(conn, %{"id" => id}, user) do
    workout = Repo.get!(user_workouts(user), id)
    changeset = Workout.changeset(workout)
    render(conn, "edit.html", workout: workout, changeset: changeset)
  end

  def update(conn, %{"id" => id, "workout" => workout_params}, user) do
    workout = user |> user_workouts |> Repo.get!(id)
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

  def delete(conn, %{"id" => id}, user) do
    workout = user |> user_workouts |> Repo.get!(id)
    Repo.delete!(workout)

    conn
    |> put_flash(:info, "Workout deleted successfully.")
    |> redirect(to: workout_path(conn, :index))
  end
end
