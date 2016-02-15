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
  @optional_fields ~w(swim_distance swim_seconds bike_distance bike_seconds run_distance run_seconds)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
