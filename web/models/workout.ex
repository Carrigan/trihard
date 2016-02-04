defmodule Trihard.Workout do
  use Trihard.Web, :model
  require IEx

  schema "workouts" do
    field :date, Ecto.Date
    field :name, :string
    belongs_to :user, Trihard.User
    has_many :exercises, Trihard.Exercise
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

  def with_exercises(model, exercises, params) do
    model
    |> changeset(params)
    |> append_exercises(exercises)
  end

  defp append_exercises(changeset, exercises) do
    cond do
      Enum.empty? exercises -> add_error(changeset, :exercises, "At least one exercise is required.")
      true -> put_assoc(changeset, :exercises, exercises)
    end
  end
end
