defmodule CWeb.PrefabLive.Index do
  use CWeb, :live_view

  alias C.Data
  alias C.Data.Prefab

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :prefabs, Data.list_prefabs())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Prefab")
    |> assign(:prefab, Data.get_prefab!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Prefab")
    |> assign(:prefab, %Prefab{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Prefabs")
    |> assign(:prefab, nil)
  end

  @impl true
  def handle_info({CWeb.PrefabLive.FormComponent, {:saved, prefab}}, socket) do
    {:noreply, stream_insert(socket, :prefabs, prefab)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    prefab = Data.get_prefab!(id)
    {:ok, _} = Data.delete_prefab(prefab)

    {:noreply, stream_delete(socket, :prefabs, prefab)}
  end
end
