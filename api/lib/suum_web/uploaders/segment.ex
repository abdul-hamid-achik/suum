defmodule Suum.Uploaders.Segment do
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @versions [:original]
  def validate({file, _}) do
    ~w(.ts) |> Enum.member?(Path.extname(file.file_name))
  end
end