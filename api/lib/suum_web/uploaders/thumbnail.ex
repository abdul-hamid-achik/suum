defmodule Suum.Uploaders.Thumbnail do
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @versions [:original]
  def validate({file, _}) do
    ~w(.jpeg .jpg .png .gif) |> Enum.member?(Path.extname(file.file_name))
  end
end
