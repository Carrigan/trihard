defmodule Trihard.Workout do
  use Trihard.Web, :model
  alias Trihard.Exercise

  schema "workouts" do
    field :date, Ecto.Date
    field :name, :string
    belongs_to :user, Trihard.User
    has_many :exercises, Trihard.Exercise, on_delete: :delete_all
    timestamps
  end

  @required_fields ~w(date name user_id)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def with_exercises(model, %{"exercises" => _} = params), do: with_exercises(model, params, "exercises")
  def with_exercises(model, %{:exercises => _} = params), do: with_exercises(model, params, :exercises)
  def with_exercises(model, _) do
    change(model)
    |> add_error(:exercises, "required")
  end

  def with_exercises(model, params, key) do
    { exercise_params, workout_params } = Map.split(params, [key])
    exercises = Map.get(exercise_params, key) |> cast_exercises()

    model
    |> changeset(workout_params)
    |> append_exercises(exercises)
  end

  defp cast_exercises(params) do
    params
    |> Enum.map(fn {_idx, str} -> Exercise.changeset(%Exercise{}, str) end)
    |> Enum.filter(&(&1.valid?))
  end

  defp append_exercises(changeset, []), do: add_error(changeset, :exercises, "required")
  defp append_exercises(changeset, exercises), do: put_assoc(changeset, :exercises, exercises)
end
