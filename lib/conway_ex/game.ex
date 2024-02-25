defmodule C.Game do
  @doc """

  Rules:
  Any live cell with fewer than two live neighbors dies, as if by underpopulation.
  Any live cell with two or three live neighbors lives on to the next generation.
  Any live cell with more than three live neighbors dies, as if by overpopulation.
  Any dead cell with exactly three live neighbors becomes a live cell, as if by reproduction.

  """

  @type population :: list({number(), number()})
  @type cell :: {number(), number()}

  @max_dimen 100

  @spec tick(population()) :: population()
  def tick(population) do
    survivors = population |> get_surviving_population()
    spawned = population |> get_spawned_population()
    spawned ++ survivors
  end

  @spec tick_detailed(population()) :: {population(), population(), population()}
  def tick_detailed(population) do
    dying = get_dying_population(population)
    spawned = get_spawned_population(population)
    {(population -- dying) ++ spawned, dying, spawned}
  end

  @spec offset_shape(population(), cell()) :: population()
  def offset_shape(cells, {x, y}) do
    Enum.map(cells, &{elem(&1, 0) + x, elem(&1, 1) + y})
  end

  @spec get_surviving_population(population()) :: population()
  def get_surviving_population(population),
    do: Enum.reject(population, &should_die?(&1, population))

  @spec get_dying_population(population()) :: population()
  def get_dying_population(population), do: Enum.filter(population, &should_die?(&1, population))

  @spec get_spawned_population(population()) :: population()
  def get_spawned_population(population) do
    population
    # get all possible spawn locations (all neighbors)
    |> Enum.map(&neighbor_coordinates/1)
    # combine the lists
    |> List.flatten()
    # dedupe so we only check once
    |> Enum.uniq()
    |> Enum.filter(&should_spawn?(&1, population))
  end

  @spec neighbor_coordinates(cell()) :: population()
  def neighbor_coordinates({x, y} = _cell) do
    # this is a circle around the cell provided
    [
      {x - 1, y - 1},
      {x, y - 1},
      {x + 1, y - 1},
      {x - 1, y},
      {x + 1, y},
      {x - 1, y + 1},
      {x, y + 1},
      {x + 1, y + 1}
    ]
  end

  @spec count_neighbors_in_population(cell(), population()) :: integer()
  def count_neighbors_in_population(cell, population) do
    # todo: incredibly inefficient, but okay for now
    neighbors = neighbor_coordinates(cell)
    non_neighboring_in_population = population -- neighbors
    length(population) - length(non_neighboring_in_population)
  end

  @spec should_die?({number(), number()}, population()) :: boolean()
  def should_die?(cell, population) do
    count_neighbors_in_population(cell, population)
    |> case do
      x when x < 2 -> true
      x when x > 3 -> true
      _ -> false
    end
    |> case do
      true -> true
      false -> !is_in_range(cell)
    end
  end

  def is_in_range({x, y}), do: abs(x) < @max_dimen && abs(y) < @max_dimen

  @spec should_spawn?(cell(), population()) :: boolean()
  def should_spawn?(cell, population) do
    count_neighbors_in_population(cell, population) === 3
  end

  @spec truncate(population(), cell()) :: population()
  def truncate(population, {max_x, max_y} = _max_dimension) do
    population
    |> Enum.reject(fn {x, y} ->
      abs(x) >= max_x || abs(y) >= max_y
    end)
  end
end
