defmodule C.Data do
  @moduledoc """
  The Data context.
  """

  import Ecto.Query, warn: false
  alias C.Repo

  alias C.Data.Prefab

  @doc """
  Returns the list of prefabs.

  ## Examples

      iex> list_prefabs()
      [%Prefab{}, ...]

  """
  def list_prefabs do
    Repo.all(Prefab)
  end

  @doc """
  Gets a single prefab.

  Raises `Ecto.NoResultsError` if the Prefab does not exist.

  ## Examples

      iex> get_prefab!(123)
      %Prefab{}

      iex> get_prefab!(456)
      ** (Ecto.NoResultsError)

  """
  def get_prefab!(id), do: Repo.get!(Prefab, id)

  @doc """
  Creates a prefab.

  ## Examples

      iex> create_prefab(%{field: value})
      {:ok, %Prefab{}}

      iex> create_prefab(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_prefab(attrs \\ %{}) do
    %Prefab{}
    |> Prefab.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a prefab.

  ## Examples

      iex> update_prefab(prefab, %{field: new_value})
      {:ok, %Prefab{}}

      iex> update_prefab(prefab, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_prefab(%Prefab{} = prefab, attrs) do
    prefab
    |> Prefab.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a prefab.

  ## Examples

      iex> delete_prefab(prefab)
      {:ok, %Prefab{}}

      iex> delete_prefab(prefab)
      {:error, %Ecto.Changeset{}}

  """
  def delete_prefab(%Prefab{} = prefab) do
    Repo.delete(prefab)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking prefab changes.

  ## Examples

      iex> change_prefab(prefab)
      %Ecto.Changeset{data: %Prefab{}}

  """
  def change_prefab(%Prefab{} = prefab, attrs \\ %{}) do
    Prefab.changeset(prefab, attrs)
  end
end
