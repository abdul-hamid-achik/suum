defmodule Suum.Pipeline do
  use Membrane.Pipeline

  # @impl true
  # def handle_init(path_to_mp3) do
  #   children = %{
  #     file: %Membrane.Element.File.Source{location: path_to_mp3},
  #     decoder: Membrane.Element.Mad.Decoder,
  #     converter: %Membrane.Element.FFmpeg.SWResample.Converter{
  #       output_caps: %Membrane.Caps.Audio.Raw{sample_rate: 48_000, format: :s16le, channels: 2}
  #     },
  #     player: Membrane.Element.PortAudio.Sink
  #   }

  #   links = [
  #     link(:file) |> to(:decoder) |> to(:converter) |> to(:player)
  #   ]

  #   spec = %ParentSpec{
  #     children: children,
  #     links: links
  #   }

  #   {{:ok, spec: spec}, %{}}
  # end
end
