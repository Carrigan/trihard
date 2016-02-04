defmodule Trihard.Exercise do
  use Trihard.Web, :model
  require IEx

  schema "exercises" do
    field :type, :string
    field :distance, :float
    field :seconds, :integer
    belongs_to :workout, Trihard.Workout
    field :present, :boolean, virtual: true

    timestamps
  end

  @required_fields ~w(type present)
  @optional_fields ~w(distance seconds)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
