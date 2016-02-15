defmodule Trihard.Workout do
  use Trihard.Web, :model

  schema "workouts" do
    field :date, Ecto.Date
    field :name, :string
    field :swim_distance, :float
    field :swim_minutes, :integer, virtual: true
    field :swim_seconds, :integer
    field :bike_distance, :float
    field :bike_minutes, :integer, virtual: true
    field :bike_seconds, :integer
    field :run_distance, :float
    field :run_minutes, :integer, virtual: true
    field :run_seconds, :integer
    belongs_to :user, Trihard.User
    timestamps
  end

  @required_fields ~w(date user_id)
  @optional_fields ~w(name)
  @exercise_fields ~w(swim_distance swim_seconds swim_minutes
                      bike_distance bike_seconds bike_minutes
                      run_distance  run_seconds  run_minutes)
  @exercise_names ~w(swim bike run)
  @exercise_atoms Enum.map(@exercise_fields, &String.to_atom/1)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @exercise_fields ++ @optional_fields)
    |> minutes_to_seconds
    |> validate_exercise_presence
  end

  def name(model) do
    model.name || String.capitalize(exercise_string(model) <> " workout on " <> Ecto.Date.to_string(model.date))
  end

  def with_minutes(model) do
    @exercise_names
    |> Enum.map(fn name -> {String.to_atom(name <> "_seconds"), String.to_atom(name <> "_minutes")} end)
    |> Enum.reduce(model, fn {sec, min}, mod -> to_minutes(mod, sec, min) end)
  end

  defp to_minutes(model, sec_key, min_key), do: to_minutes(model, sec_key, min_key, Map.get(model, sec_key))
  defp to_minutes(model, _, _, nil), do: model
  defp to_minutes(model, sec_key, min_key, seconds) do
    model
    |> Map.put(min_key, div(seconds, 60))
    |> Map.put(sec_key, rem(seconds, 60))
  end

  defp minutes_to_seconds(changeset) do
    changeset
    |> convert_minutes_to_seconds(:swim_seconds, :swim_minutes)
    |> convert_minutes_to_seconds(:bike_seconds, :bike_minutes)
    |> convert_minutes_to_seconds(:run_seconds, :run_minutes)
  end

  defp convert_minutes_to_seconds(changeset, sec, min) do
    put_change(changeset, sec, m_to_s(get_field(changeset, min), get_field(changeset, sec)))
  end

  defp m_to_s(nil, nil), do: nil
  defp m_to_s(mins, nil), do: mins * 60
  defp m_to_s(nil, secs), do: secs
  defp m_to_s(mins, secs), do: mins * 60 + secs

  defp exercise_string(model) do
    Enum.map(@exercise_atoms, fn field -> Map.get(model, field) end)
    |> Enum.chunk(3)
    |> Enum.map(&Enum.any?/1)
    |> Enum.zip(@exercise_names)
    |> Enum.filter(fn {present, _} -> present end)
    |> Enum.map(fn {_, name} -> name end)
    |> Enum.join(" and ")
  end

  defp validate_exercise_presence(changeset) do
    if Enum.all?(@exercise_atoms, fn field -> get_field(changeset, field) == nil end) do
      add_error(changeset, :exercises, "At least one exercise is required.")
    else
      changeset
    end
  end
end
