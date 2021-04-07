defmodule Suum.Hls.Transmissions.Kickstarter do
  use GenServer

  def start_link(args) do
    Genserver.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(opts) do
    {:ok, opts}
  end

  def handle_call({:boot, transmission_uuid}, _state) do
  end
end
