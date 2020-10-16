defmodule Suum.Organizer.Room.ShowLive do
  @moduledoc """
  A LiveView for creating and joining chat rooms.
  """

  use SuumWeb, :live_view
  alias Suum.ConnectedUser
  alias Suum.Organizer
  alias SuumWeb.Presence
  alias Phoenix.Socket.Broadcast

  @impl true
  def render(assigns) do
    ~L"""
    <h1 class="title"><%= @room.title %></h1>
    <h3 class="subtitle">Connected Users:</h3>
    <ul>
      <%= for uuid <- @connected_users do %>
        <li><%= uuid %></li>
      <% end %>
    </ul>
    <div class="streams tile is-ancestor">
      <div class="tile is-8 is-parent">

        <video id="local-video" class="tile is-" playsinline autoplay muted></video>
      </div>

      <div class="tile is-parent">
        <%= for uuid <- @connected_users do %>
          <div class="tile is-child">
            <video id="video-remote-<%= uuid %>" data-user-uuid="<%= uuid %>" playsinline autoplay phx-hook="InitUser"></video>
          </div>
        <% end %>
      </div>
    </div>

    <button class="button" phx-hook="JoinCall" phx-click="join_call" id="join-call">Join Call</button>

    <div id="offer-requests" class="tile is-parent">
      <%= for request <- @offer_requests do %>
      <span phx-hook="HandleOfferRequest" class="tile is-child" data-from-user-uuid="<%= request.from_user.uuid %>"></span>
      <% end %>
    </div>

    <div id="sdp-offers" class="tile is-parent">
      <%= for sdp_offer <- @sdp_offers do %>
      <span phx-hook="HandleSdpOffer" class="tile is-child" data-from-user-uuid="<%= sdp_offer["from_user"] %>" data-sdp="<%= sdp_offer["description"]["sdp"] %>"></span>
      <% end %>
    </div>

    <div id="sdp-answers" class="tile is-parent">
      <%= for answer <- @answers do %>
      <span phx-hook="HandleAnswer" class="tile is-child" data-from-user-uuid="<%= answer["from_user"] %>" data-sdp="<%= answer["description"]["sdp"] %>"></span>
      <% end %>
    </div>

    <div id="ice-candidates" class="tile is-parent">
      <%= for ice_candidate_offer <- @ice_candidate_offers do %>
      <span phx-hook="HandleIceCandidateOffer" class="tile is-child" data-from-user-uuid="<%= ice_candidate_offer["from_user"] %>" data-ice-candidate="<%= Jason.encode!(ice_candidate_offer["candidate"]) %>"></span>
      <% end %>
    </div>
    """
  end

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    user = create_connected_user()
    Phoenix.PubSub.subscribe(Suum.PubSub, "room:" <> slug)
    Phoenix.PubSub.subscribe(Suum.PubSub, "room:" <> slug <> ":" <> user.uuid)
    {:ok, _} = Presence.track(self(), "room:" <> slug, user.uuid, %{})

    case Organizer.get_room(slug) do
      nil ->
        {:ok,
         socket
         |> put_flash(:error, "That room does not exist.")
         |> push_redirect(to: Routes.room_new_path(socket, :new))}

      room ->
        {:ok,
         socket
         |> assign(:room, room)
         |> assign(:user, user)
         |> assign(:slug, slug)
         |> assign(:connected_users, [])
         |> assign(:offer_requests, [])
         |> assign(:ice_candidate_offers, [])
         |> assign(:sdp_offers, [])
         |> assign(:answers, [])}
    end
  end

  @impl true
  def handle_event("join_call", _params, socket) do
    for user <- socket.assigns.connected_users do
      send_direct_message(
        socket.assigns.slug,
        user,
        "request_offers",
        %{
          from_user: socket.assigns.user
        }
      )
    end

    {:noreply, socket}
  end

  @impl true
  def handle_event("new_ice_candidate", payload, socket) do
    payload = Map.merge(payload, %{"from_user" => socket.assigns.user.uuid})

    send_direct_message(socket.assigns.slug, payload["toUser"], "new_ice_candidate", payload)
    {:noreply, socket}
  end

  @impl true
  def handle_event("new_sdp_offer", payload, socket) do
    payload = Map.merge(payload, %{"from_user" => socket.assigns.user.uuid})

    send_direct_message(socket.assigns.slug, payload["toUser"], "new_sdp_offer", payload)
    {:noreply, socket}
  end

  @impl true
  def handle_event("new_answer", payload, socket) do
    payload = Map.merge(payload, %{"from_user" => socket.assigns.user.uuid})

    send_direct_message(socket.assigns.slug, payload["toUser"], "new_answer", payload)
    {:noreply, socket}
  end

  @impl true
  def handle_info(%Broadcast{event: "new_ice_candidate", payload: payload}, socket) do
    {:noreply,
     socket
     |> assign(:ice_candidate_offers, socket.assigns.ice_candidate_offers ++ [payload])}
  end

  @impl true
  def handle_info(%Broadcast{event: "new_sdp_offer", payload: payload}, socket) do
    {:noreply,
     socket
     |> assign(:sdp_offers, socket.assigns.ice_candidate_offers ++ [payload])}
  end

  @impl true
  def handle_info(%Broadcast{event: "new_answer", payload: payload}, socket) do
    {:noreply,
     socket
     |> assign(:answers, socket.assigns.answers ++ [payload])}
  end

  @impl true
  @doc """
  When an offer request has been received, add it to the `@offer_requests` list.
  """
  def handle_info(%Broadcast{event: "request_offers", payload: request}, socket) do
    {:noreply,
     socket
     |> assign(:offer_requests, socket.assigns.offer_requests ++ [request])}
  end

  @impl true
  def handle_info(%Broadcast{event: "presence_diff"}, socket) do
    {:noreply,
     socket
     |> assign(:connected_users, list_present(socket))}
  end

  defp list_present(socket) do
    Presence.list("room:" <> socket.assigns.slug)
    |> Enum.map(fn {k, _} -> k end)
  end

  defp send_direct_message(slug, to_user, event, payload) do
    SuumWeb.Endpoint.broadcast_from(
      self(),
      "room:" <> slug <> ":" <> to_user,
      event,
      payload
    )
  end

  defp create_connected_user do
    %ConnectedUser{uuid: UUID.uuid4()}
  end
end
