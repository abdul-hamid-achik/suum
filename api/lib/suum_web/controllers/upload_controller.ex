defmodule SuumWeb.UploadController do
  @transmissions_base_path "./mnt/uploads"

  use Tus.Controller
  use SuumWeb, :controller
  require Logger

  alias Suum.Hls.Transmissions.Observer
  alias Suum.Hls

  def on_begin_upload(
        %Tus.File{
          metadata: [
            {"name", _filename},
            {"type", _filetype},
            {"transmission_uuid", transmission_uuid}
          ]
        } = _file
      ) do
    {:ok, pid} =
      Observer.start_link(%{
        transmission_uuid: transmission_uuid,
        transmissions_base_path: "#{@transmissions_base_path}"
      })

    %Hls.Transmission{} = transmission = Hls.get_transmission(transmission_uuid)

    {:ok, %Hls.Transmission{}} =
      Hls.update_transmission(transmission, %{pid: "#{:erlang.pid_to_list(pid)}"})

    :ok
  end

  def on_complete_upload(
        %Tus.File{
          metadata: [
            {"name", filename},
            {"type", filetype},
            {"transmission_uuid", transmission_uuid}
          ],
          uid: uid
        } = _file
      ) do
    case Hls.get_transmission(transmission_uuid) do
      nil ->
        Logger.error("problem processing transmission #{transmission_uuid}")
        :ok

      transmission when not is_nil(transmission) ->
        pid =
          transmission.pid
          |> :erlang.binary_to_list()
          |> :erlang.list_to_pid()

        GenServer.cast(
          pid,
          {:process, %{filename: filename, filetype: filetype, uid: uid}}
        )
    end
  end
end
