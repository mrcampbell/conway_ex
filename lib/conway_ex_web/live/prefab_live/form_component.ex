defmodule CWeb.PrefabLive.FormComponent do
  use CWeb, :live_component

  alias C.Data

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage prefab records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="prefab-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:data]} type="text" label="Data" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Prefab</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{prefab: prefab} = assigns, socket) do
    changeset = Data.change_prefab(prefab)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"prefab" => prefab_params}, socket) do
    changeset =
      socket.assigns.prefab
      |> Data.change_prefab(prefab_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"prefab" => prefab_params}, socket) do
    save_prefab(socket, socket.assigns.action, prefab_params)
  end

  defp save_prefab(socket, :edit, prefab_params) do
    case Data.update_prefab(socket.assigns.prefab, prefab_params) do
      {:ok, prefab} ->
        notify_parent({:saved, prefab})

        {:noreply,
         socket
         |> put_flash(:info, "Prefab updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_prefab(socket, :new, prefab_params) do
    case Data.create_prefab(prefab_params) do
      {:ok, prefab} ->
        notify_parent({:saved, prefab})

        {:noreply,
         socket
         |> put_flash(:info, "Prefab created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
