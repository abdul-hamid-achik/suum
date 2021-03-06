defmodule Suum.Uploaders.Segment do
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @versions [:original]
  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  end
end
