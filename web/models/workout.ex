defmodule Trihard.Workout do
  use Trihard.Web, :model

  schema "workouts" do
    field :date, Ecto.Date
    field :name, :string
    belongs_to :user, Trihard.User

    timestamps
  end

  @required_fields ~w(date name user_id)
  @optional_fields ~w()

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
