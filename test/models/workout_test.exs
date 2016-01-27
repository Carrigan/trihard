defmodule Trihard.WorkoutTest do
  use Trihard.ModelCase

  alias Trihard.Workout

  @valid_attrs %{date: "2010-04-17", name: "some content", user_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Workout.changeset(%Workout{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Workout.changeset(%Workout{}, @invalid_attrs)
    refute changeset.valid?
  end
end
