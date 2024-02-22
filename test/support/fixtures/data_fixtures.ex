defmodule C.DataFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `C.Data` context.
  """

  @doc """
  Generate a prefab.
  """
  def prefab_fixture(attrs \\ %{}) do
    {:ok, prefab} =
      attrs
      |> Enum.into(%{
        data: "some data",
        name: "some name"
      })
      |> C.Data.create_prefab()

    prefab
  end
end
