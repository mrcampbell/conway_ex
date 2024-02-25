defmodule C.Data.Prefab do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "prefabs" do
    # blinker
    field :data, :string, default: "3.3,3.4,3.2"
    field :name, :string, default: "blinker"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(prefab, attrs) do
    prefab
    |> cast(attrs, [:name, :data])
    |> validate_required([:name, :data])
  end
end
