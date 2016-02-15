defmodule Trihard.WorkoutTest do
  use Trihard.ModelCase
  alias Trihard.Workout
  require IEx

  @no_exercise_attrs %{user_id: 1, date: {2012, 1, 1}, name: "some content"}
  @valid_attrs %{user_id: 1, date: {2012, 1, 1}, name: "some content",
    swim_distance: 10.1, swim_seconds: 30, swim_minutes: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
     changeset = Workout.changeset(%Workout{}, @valid_attrs)
     assert changeset.valid?
  end

  test "converts minutes to seconds" do
    changeset = Workout.changeset(%Workout{}, @valid_attrs)
    assert Ecto.Changeset.get_field(changeset, :swim_seconds) == 90
  end

  test "converts seconds to minutes" do
    model = %Workout{swim_seconds: 90} |> Workout.with_minutes
    assert model.swim_seconds == 30
    assert model.swim_minutes == 1
  end

  test "changeset without any exercises" do
     changeset = Workout.changeset(%Workout{}, @no_exercise_attrs)
     refute changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Workout.changeset(%Workout{}, @invalid_attrs)
    refute changeset.valid?
  end
end
