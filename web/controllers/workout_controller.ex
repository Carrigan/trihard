defmodule Trihard.WorkoutController do
  use Trihard.Web, :controller

  alias Trihard.Workout

  plug :scrub_params, "workout" when action in [:create, :update]

  def index(conn, _params) do
    workouts = Repo.all(Workout)
    render(conn, "index.html", workouts: workouts)
  end

  def new(conn, _params) do
    changeset = Workout.changeset(%Workout{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"workout" => workout_params}) do
    changeset = Workout.changeset(%Workout{}, workout_params)

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
