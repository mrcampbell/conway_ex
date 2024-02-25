defmodule CWeb.GameLive.Index do
  use CWeb, :live_view

  @tick_rate 100
  @glider [{-1, 0}, {0, 0}, {1, 0}, {1, 1}, {0, 2}]

  alias C.Game

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(@tick_rate, self(), :tick)
    if connected?(socket), do: :timer.send_interval(@tick_rate * 100, self(), :truncate)

    population = @glider

    {:ok,
     socket
     |> assign(:population, population)
     |> assign(:max_dimension, 100)
     |> assign(:max_x, 100)
     |> assign(:max_y, 100)
     |> assign(:show_info_modal, false)
     |> push_event("apply_tick", %{kill: [], spawn: population |> tuples_to_lists}),
     layout: false}
  end

  @impl true
  def handle_event("cell_click", %{"x" => x, "y" => y}, socket) do
    new_glider = Game.offset_shape(@glider, {x, y})

    {:noreply, socket |> assign(:population, socket.assigns.population ++ new_glider)}
  end

  @impl true
  def handle_event("screen_dimensions", %{"x" => x, "y" => y}, socket) do
    {:noreply, socket |> assign(:max_x, x) |> assign(:max_y, y)}
  end

  @impl true
  def handle_info(:tick, socket) do
    last_population = socket.assigns.population
    {next_population, dying, spawned} = Game.tick_detailed(last_population)

    {:noreply,
     socket
     |> push_event("apply_tick", %{
       kill: dying |> tuples_to_lists,
       spawn: spawned |> tuples_to_lists
     })
     |> assign(:population, next_population)}
  end

  @impl true
  def handle_info(:truncate, socket) do
    IO.puts("truncate")
    last_population = socket.assigns.population
    next_population = Game.truncate(last_population, {socket.assigns.max_x, socket.assigns.max_y})

    killed_by_truncation = last_population -- next_population

    {:noreply,
     socket
     |> push_event("apply_tick", %{
       kill: killed_by_truncation |> tuples_to_lists,
       spawn: []
     })
     |> assign(:population, next_population)}
  end

  defp tuples_to_lists(tupes), do: Enum.map(tupes, &tuple_to_list/1)
  defp tuple_to_list({x, y}), do: [x, y]
end
