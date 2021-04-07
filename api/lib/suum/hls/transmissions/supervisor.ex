defmodule Suum.Hls.Transmissions.Supervisor do
  use GenServer

  alias Suum.Hls.Transmissions.{Kickstarter, Service}
  alias Suum.Hls

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def child_spec() do
    %{
      id: Kickstarter
    }
  end

  def init(opts) do
    {:ok, opts}
  end

  def handle_info({:start, uuid}, state) do
    transmission = Hls.get_transmission(uuid)

    {:ok, pid} =
      GenServer.start_link(Service,
        transmission: transmission,
        previous_lines: [],
        name: uuid
      )

    IO.inspect(pid)
    {:noreply, state}
  end
end
