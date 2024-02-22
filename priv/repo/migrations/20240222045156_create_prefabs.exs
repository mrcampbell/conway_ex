defmodule C.Repo.Migrations.CreatePrefabs do
  use Ecto.Migration

  def change do
    create table(:prefabs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :data, :string

      timestamps(type: :utc_datetime)
    end
  end
end
