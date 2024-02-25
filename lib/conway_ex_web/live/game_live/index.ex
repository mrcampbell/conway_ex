defmodule CWeb.GameLive.Index do
  use CWeb, :live_view

  @tick_rate 100
  @glider [{-1, 0}, {0, 0}, {1, 0}, {1, 1}, {0, 2}]

  alias C.Game

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(@tick_rate, self(), :tick)

    population = @glider

    {:ok,
     socket
     |> assign(:population, population)
     |> push_event("apply_tick", %{kill: [], spawn: population |> tuples_to_lists})}
  end

  @impl true
  def handle_event("cell_click", %{"x" => x, "y" => y}, socket) do
    new_glider = Game.offset_shape(@glider, {x, y})

    {:noreply, socket |> assign(:population, socket.assigns.population ++ new_glider)}
  end

  @impl true
  def handle_info(:tick, socket) do
    last_population = socket.assigns.population
    dying_population = Game.get_dying_population(last_population) |> tuples_to_lists()
    spawned_population = Game.get_spawned_population(last_population) |> tuples_to_lists()

    {:noreply,
     socket
     |> push_event("apply_tick", %{kill: dying_population, spawn: spawned_population})
     |> assign(:population, Game.tick(last_population))}
  end

  defp tuples_to_lists(tupes), do: Enum.map(tupes, &tuple_to_list/1)
  defp tuple_to_list({x, y}), do: [x, y]
end
