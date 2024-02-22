defmodule C.Data.Prefab do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "prefabs" do
    field :data, :string
    field :name, :string

    field :cells, {:array, :map}, virtual: true, default: []
    field :height, :integer, virtual: true, default: 9
    field :width, :integer, virtual: true, default: 9

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(prefab, attrs) do
    prefab
    |> cast(attrs, [:name, :data, :cells])
    |> validate_required([:name, :data])
  end
end
