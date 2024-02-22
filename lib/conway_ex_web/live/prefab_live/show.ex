defmodule CWeb.PrefabLive.Show do
  use CWeb, :live_view

  alias C.Data

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:prefab, Data.get_prefab!(id))}
  end

  defp page_title(:show), do: "Show Prefab"
  defp page_title(:edit), do: "Edit Prefab"
end
