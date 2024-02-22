defmodule C.DataTest do
  use C.DataCase

  alias C.Data

  describe "prefabs" do
    alias C.Data.Prefab

    import C.DataFixtures

    @invalid_attrs %{data: nil, name: nil}

    test "list_prefabs/0 returns all prefabs" do
      prefab = prefab_fixture()
      assert Data.list_prefabs() == [prefab]
    end

    test "get_prefab!/1 returns the prefab with given id" do
      prefab = prefab_fixture()
      assert Data.get_prefab!(prefab.id) == prefab
    end

    test "create_prefab/1 with valid data creates a prefab" do
      valid_attrs = %{data: "some data", name: "some name"}

      assert {:ok, %Prefab{} = prefab} = Data.create_prefab(valid_attrs)
      assert prefab.data == "some data"
      assert prefab.name == "some name"
    end

    test "create_prefab/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.create_prefab(@invalid_attrs)
    end

    test "update_prefab/2 with valid data updates the prefab" do
      prefab = prefab_fixture()
      update_attrs = %{data: "some updated data", name: "some updated name"}

      assert {:ok, %Prefab{} = prefab} = Data.update_prefab(prefab, update_attrs)
      assert prefab.data == "some updated data"
      assert prefab.name == "some updated name"
    end

    test "update_prefab/2 with invalid data returns error changeset" do
      prefab = prefab_fixture()
      assert {:error, %Ecto.Changeset{}} = Data.update_prefab(prefab, @invalid_attrs)
      assert prefab == Data.get_prefab!(prefab.id)
    end

    test "delete_prefab/1 deletes the prefab" do
      prefab = prefab_fixture()
      assert {:ok, %Prefab{}} = Data.delete_prefab(prefab)
      assert_raise Ecto.NoResultsError, fn -> Data.get_prefab!(prefab.id) end
    end

    test "change_prefab/1 returns a prefab changeset" do
      prefab = prefab_fixture()
      assert %Ecto.Changeset{} = Data.change_prefab(prefab)
    end
  end
end
