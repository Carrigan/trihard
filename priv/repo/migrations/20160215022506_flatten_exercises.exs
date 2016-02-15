defmodule Trihard.Repo.Migrations.FlattenExercises do
  use Ecto.Migration

  def change do
    alter table(:workouts) do
      add :swim_distance, :float
      add :swim_seconds, :integer
      add :bike_distance, :float
      add :bike_seconds, :integer
      add :run_distance, :float
      add :run_seconds, :integer
    end

    drop table(:exercises)
  end
end
