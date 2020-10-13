defmodule SuumWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers

  @doc """
  Renders a component inside the `SuumWeb.ModalComponent` component.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <%= live_modal @socket, SuumWeb.TwoCamerasLive.FormComponent,
        id: @two_cameras.id || :new,
        action: @live_action,
        two_cameras: @two_cameras,
        return_to: Routes.two_cameras_index_path(@socket, :index) %>
  """
  def live_modal(socket, component, opts) do
    path = Keyword.fetch!(opts, :return_to)
    modal_opts = [id: :modal, return_to: path, component: component, opts: opts]
    live_component(socket, SuumWeb.ModalComponent, modal_opts)
  end
end
