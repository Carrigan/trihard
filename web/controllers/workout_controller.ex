defmodule Trihard.WorkoutController do
  use Trihard.Web, :controller
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
    changeset = Workout.changeset(%Workout{date: Ecto.Date.utc})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"workout" => params}, user) do
    workout = user |> build_assoc(:workouts) |> Workout.changeset(params)

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

    workout
    |> Workout.changeset(workout_params)
    |> Repo.update
    |> render_update(conn, workout)
  end

  def render_update({:ok, workout}, conn, _) do
    conn
    |> put_flash(:info, "Workout updated successfully.")
    |> redirect(to: workout_path(conn, :show, workout))
  end

  def render_update({:error, changeset}, conn, workout) do
    render(conn, "edit.html", workout: workout, changeset: changeset)
  end

  def delete(conn, %{"id" => id}, user) do
    user |> user_workouts |> Repo.get!(id) |> Repo.delete!

    conn
    |> put_flash(:info, "Workout deleted successfully.")
    |> redirect(to: workout_path(conn, :index))
  end
end
