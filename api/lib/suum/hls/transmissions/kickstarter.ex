defmodule Suum.Hls.Transmissions.Kickstarter do
  use DynamicSupervisor
  alias Suum.Hls.Transmissions.Service

  def start_link(arg),
    do: DynamicSupervisor.start_link(__MODULE__, arg, name: __MODULE__)

  def init(_arg),
    do: DynamicSupervisor.init(strategy: :one_for_one)

  def process(transmission),
    do:
      DynamicSupervisor.start_child(
        __MODULE__,
        {Service, [transmission: transmission, previous_lines: []]}
      )
end
