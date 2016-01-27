defmodule Trihard.Repo.Migrations.CreateWorkout do
  use Ecto.Migration

  def change do
    create table(:workouts) do
      add :date, :date
      add :name, :string
      add :user_id, references(:users)

      timestamps
    end

  end
end
