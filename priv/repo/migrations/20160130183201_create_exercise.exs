defmodule Trihard.Repo.Migrations.CreateExercise do
  use Ecto.Migration

  def change do
    create table(:exercises) do
      add :type, :string
      add :distance, :float
      add :seconds, :integer
      add :workout_id, references(:workouts, on_delete: :nothing)

      timestamps
    end
    create index(:exercises, [:workout_id])

  end
end
