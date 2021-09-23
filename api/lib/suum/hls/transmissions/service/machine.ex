defmodule Suum.Hls.Transmissions.Machine do
  alias Suum.Hls.Transmissions.Service.State
  require Logger

  use Machinery,
    states: ["created", "waiting", "streaming", "uploading", "processing", "ready", "error"],
    transitions: %{
      "created" => ["waiting", "streaming", "uploading"],
      "waiting" => ["streaming", "uploading"],
      "uploading" => "streaming",
      "streaming" => "processing",
      "processing" => "ready",
      "error" => "waiting",
      "*" => "error"
    },
    field: :status

  def persist(state, next_state) do
    {:ok, %State{} = updated_state} = State.transition_to(state, next_state)
    updated_state
  end

  def log_transition(transmission, next_state) do
    Logger.info("Transmission #{transmission.uuid} - #{transmission.state} => #{next_state}")
    transmission
  end

  def guard_transition(transmission, _state), do: transmission

  def before_transition(transmission, state) do
    Logger.info("#{transmission.state} - #{state}")
    transmission
  end

  # def before_transition(transmission, _state), do: transmission

  def after_transition(transmission, "uploading") do
    Logger.info("uploading #{transmission.uuid}")

    GenServer.cast(
      pid(transmission.uuid),
      {:uploading, transmission}
    )
  end

  def after_transition(transmission, "processing") do
    Logger.info("processing #{transmission.uuid}")

    GenServer.cast(
      pid(transmission.uuid),
      {:processing, transmission}
    )
  end

  def after_transition(transmission, "streaming") do
    Logger.info("streaming #{transmission.uuid}")

    GenServer.cast(
      pid(transmission.uuid),
      {:streaming, transmission}
    )
  end

  def after_transition(transmission, _state), do: transmission

  defp pid(uuid), do: get_from_registry(Registry.lookup(TransmissionRegistry, uuid))

  defp get_from_registry([{pid, _}]), do: pid
  defp get_from_registry([]), do: nil
end
