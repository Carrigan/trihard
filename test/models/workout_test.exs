defmodule Trihard.WorkoutTest do
  use Trihard.ModelCase
  alias Trihard.Workout

  @no_exercise_attrs %{user_id: 1, date: {2012, 1, 1}, name: "some content"}
  @valid_attrs %{user_id: 1, date: {2012, 1, 1}, name: "some content",
    swim_distance: 10.1, swim_seconds: 100}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
     changeset = Workout.changeset(%Workout{}, @valid_attrs)
     assert changeset.valid?
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
