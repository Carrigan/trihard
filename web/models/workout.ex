defmodule Trihard.Workout do
  use Trihard.Web, :model

  schema "workouts" do
    field :date, Ecto.Date
    field :name, :string
    field :swim_distance, :float
    field :swim_seconds, :integer
    field :bike_distance, :float
    field :bike_seconds, :integer
    field :run_distance, :float
    field :run_seconds, :integer
    belongs_to :user, Trihard.User
    timestamps
  end

  @required_fields ~w(date name user_id)
  @exercise_fields ~w(swim_distance swim_seconds bike_distance bike_seconds run_distance run_seconds)
  @exercise_atoms Enum.map(@exercise_fields, &String.to_atom/1)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @exercise_fields)
    |> validate_exercise_presence
  end

  defp validate_exercise_presence(changeset) do
    if Enum.all?(@exercise_atoms, fn field -> get_field(changeset, field) == nil end) do
      add_error(changeset, :exercises, "At least one exercise is required.")
    else
      changeset
    end
  end
end
