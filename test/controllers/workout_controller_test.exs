defmodule Trihard.WorkoutControllerTest do
  use Trihard.ConnCase
  alias Trihard.Workout
  alias Trihard.User
  require IEx

  @user_attrs %{name: "lcp", email: "abc@gmail.com", password: "password"}
  @swim_attrs %{type: "swim", present: true}
  @bike_attrs %{type: "bike", present: false}
  @valid_attrs %{date: {2012, 1, 1}, name: "some content",
    exercises: %{ 0 => @swim_attrs, 1 => @bike_attrs }}
  @invalid_attrs %{name: 10}

  setup %{conn: conn} = config do
    user = User.changeset(%User{}, @user_attrs) |> Repo.insert!
    conn = assign(conn, :current_user, user)

    if config[:with_workout] do
      workout = user
        |> build_assoc(:workouts)
        |> Workout.with_exercises(@valid_attrs)
        |> Repo.insert!

      {:ok, conn: conn, user: user, workout: workout}
    else
      {:ok, conn: conn, user: user}
    end
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, workout_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing workouts"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, workout_path(conn, :new)
    assert html_response(conn, 200) =~ "New workout"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, workout_path(conn, :create), workout: @valid_attrs
    assert redirected_to(conn) == workout_path(conn, :index)
    assert Repo.one(from x in Workout, order_by: [desc: x.id], limit: 1)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, workout_path(conn, :create), workout: @invalid_attrs
    assert html_response(conn, 200) =~ "New workout"
  end

  @tag with_workout: true
  test "shows chosen resource", %{conn: conn, workout: workout} do
    conn = get conn, workout_path(conn, :show, workout)
    assert html_response(conn, 200) =~ "Show workout"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, workout_path(conn, :show, -1)
    end
  end

  @tag with_workout: true
  test "renders form for editing chosen resource", %{conn: conn, workout: workout} do
    conn = get conn, workout_path(conn, :edit, workout)
    assert html_response(conn, 200) =~ "Edit workout"
  end

  @tag with_workout: true
  test "updates chosen resource and redirects when data is valid", %{conn: conn, workout: workout} do
    conn = put conn, workout_path(conn, :update, workout), workout: @valid_attrs
    assert redirected_to(conn) == workout_path(conn, :show, workout)
    assert Repo.get(Workout, workout.id)
  end

  @tag with_workout: true
  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, workout: workout} do
    conn = put conn, workout_path(conn, :update, workout), workout: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit workout"
  end

  @tag with_workout: true
  test "deletes chosen resource", %{conn: conn, workout: workout} do
    conn = delete conn, workout_path(conn, :delete, workout)
    assert redirected_to(conn) == workout_path(conn, :index)
    refute Repo.get(Workout, workout.id)
  end
end
