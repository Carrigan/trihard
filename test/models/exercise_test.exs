defmodule Trihard.ExerciseTest do
  use Trihard.ModelCase

  alias Trihard.Exercise

  @valid_attrs %{distance: "120.5", seconds: 42, type: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Exercise.changeset(%Exercise{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Exercise.changeset(%Exercise{}, @invalid_attrs)
    refute changeset.valid?
  end
end
