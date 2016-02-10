defmodule Trihard.WorkoutController do
  use Trihard.Web, :controller
  alias Trihard.Exercise
  alias Trihard.Workout

  plug :scrub_params, "workout" when action in [:create, :update]

  def action(conn, _) do
    apply(__MODULE__, action_name(conn),
      [conn, conn.params, conn.assigns.current_user])
  end

  def user_workouts(user) do
    assoc(user, :workouts)
  end

  def index(conn, _params, user) do
    workouts = user |> user_workouts |> Repo.all
    render(conn, "index.html", workouts: workouts)
  end

  def new(conn, _params, _user) do
    changeset = Workout.changeset(%Workout{
      date: Ecto.Date.utc,
      exercises: Enum.map(~w(swim bike run), &(%Exercise{type: &1}))})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"workout" => params}, user) do
    workout = user
      |> build_assoc(:workouts)
      |> Workout.with_exercises(params)

    case Repo.insert(workout) do
      {:ok, _workout} ->
        conn
        |> put_flash(:info, "Workout created successfully.")
        |> redirect(to: workout_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, user) do
    workout = user |> user_workouts |> Repo.get!(id) |> Repo.preload(:exercises)
    render(conn, "show.html", workout: workout)
  end

  def edit(conn, %{"id" => id}, user) do
    workout = Repo.get!(user_workouts(user), id) |> Repo.preload(:exercises)
    changeset = Workout.with_fill(workout)
    render(conn, "edit.html", workout: workout, changeset: changeset)
  end

  def update(conn, %{"id" => id, "workout" => workout_params}, user) do
    workout = user |> user_workouts |> Repo.get!(id) |> Repo.preload(:exercises)
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
