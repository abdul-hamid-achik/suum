defmodule Suum.Organizer.Room.NewLive do
  use SuumWeb, :live_view

  alias Suum.Repo
  alias Suum.Organizer.Room

  @impl true
  def render(assigns) do
    ~L"""
    <h1 class="title is-spaced">Create a New Room</h1>
    <div>
      <%= form_for @changeset, "#", [phx_change: "validate", phx_submit: "save"], fn f -> %>
        <div class="field">
          <div class="control">
            <%= text_input f, :title, placeholder: "Title", class: "input" %>
            <%= error_tag f, :title %>
          </div>
        </div>

        <div class="field">
          <div class="control">
          <%= text_input f, :slug, placeholder: "room-slug", class: "input" %>
          <%= error_tag f, :slug %>
          </div>
        </div>

        <div class="field">
          <%= submit "Save", class: "button" %>
        </div>
      <% end %>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> put_changeset()}
  end

  @impl true
  def handle_event("validate", %{"room" => room_params}, socket) do
    {:noreply,
     socket
     |> put_changeset(room_params)}
  end

  def handle_event("save", _, %{assigns: %{changeset: changeset}} = socket) do
    case Repo.insert(changeset) do
      {:ok, room} ->
        {:noreply,
         socket
         |> push_redirect(to: Routes.room_show_path(socket, :show, room.slug))}

      {:error, changeset} ->
        {:noreply,
         socket
         |> assign(:changeset, changeset)
         |> put_flash(:error, "Could not save the room.")}
    end
  end

  defp put_changeset(socket, params \\ %{}) do
    socket
    |> assign(:changeset, Room.changeset(%Room{}, params))
  end
end
