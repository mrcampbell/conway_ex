defmodule C.Data.Prefab do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "prefabs" do
    field :data, :string
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(prefab, attrs) do
    prefab
    |> cast(attrs, [:name, :data])
    |> validate_required([:name, :data])
  end
end
