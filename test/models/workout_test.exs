defmodule Trihard.WorkoutTest do
  use Trihard.ModelCase
  alias Trihard.Workout

  @swim_attrs %{type: "swim", present: true}
  @bike_attrs %{type: "bike", present: false}
  @valid_attrs %{user_id: 1, date: {2012, 1, 1}, name: "some content",
    exercises: %{ "0" => @swim_attrs, "1" => @bike_attrs } }
  @no_exercises %{"user_id" => 1, "date" => {2012, 1, 1}, "name" => "some content",
    "exercises" => %{ "0" => @bike_attrs } }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
     changeset = Workout.with_exercises(%Workout{}, @valid_attrs)
     assert changeset.valid?
  end

  test "changeset with no workouts attributes" do
     changeset = Workout.with_exercises(%Workout{}, @no_exercises)
     refute changeset.valid?
  end

  test "filters invalid exercises" do
    len = Workout.with_exercises(%Workout{}, @valid_attrs)
    |> fetch_change(:exercises)
    |> ok
    |> Enum.count

    assert len == 1
  end

  def ok({:ok, change}), do: change

  test "changeset with invalid attributes" do
    changeset = Workout.changeset(%Workout{}, @invalid_attrs)
    refute changeset.valid?
  end
end
