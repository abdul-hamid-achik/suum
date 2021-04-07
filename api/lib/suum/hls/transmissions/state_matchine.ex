defmodule Suum.Hls.Transmissions.StateMachine do
  alias Suum.{Hls, Hls.Transmissions.Service}
  require Logger

  use Machinery,
    states: ["created", "streaming", "uploading", "processing", "ready", "error"],
    transitions: %{
      "created" => ["streaming", "uploading"],
      "uploading" => "streaming",
      "streaming" => "processing",
      "processing" => "ready",
      "*" => "error"
    }

  def persist(transmission, next_state) do
    {:ok, transmission} = Hls.update_transmission(transmission, %{state: next_state})
    transmission
  end

  def log_transition(transmission, next_state) do
    Logger.info("Transmission #{transmission.uuid} - #{transmission.state} => #{next_state}")
    transmission
  end

  def guard_transition(transmission, _state), do: transmission

  def before_transition(transmission, _state), do: transmission

  def after_transition(transmission, "uploading") do
    Logger.info("uploading #{transmission.uuid}")

    GenServer.cast(
      Service,
      {:uploading, [transmission: transmission]}
    )
  end

  def after_transition(transmission, "processing") do
    Logger.info("processing #{transmission.uuid}")

    GenServer.cast(
      Service,
      {:processing, [transmission: transmission]}
    )
  end

  def after_transition(transmission, "streaming") do
    Logger.info("transmitting #{transmission.uuid}")

    GenServer.cast(
      Service,
      {:streaming, [transmission: transmission]}
    )
  end

  def after_transition(transmission, _state), do: transmission
end
