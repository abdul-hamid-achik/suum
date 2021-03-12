defmodule Suum.Uploaders.Sprite do
  use Waffle.Definition
  use Waffle.Ecto.Definition
  alias Suum.Hls.Transmission

  @acl :public_read
  @versions [:original]

  def validate({file, _}) do
    Path.extname(file.file_name) == ".png"
  end

  def storage_dir(_version, {_file, %Transmission{uuid: transmission_uuid}}),
    do: "/transmissions/#{transmission_uuid}/thumbnails/"

  def storage_dir(_version, {%Waffle.File{path: "./mnt/hls/live/" <> file_path}, _scope}) do
    [transmission_uuid, _file] = String.split(file_path, "/")
    "/transmissions/#{transmission_uuid}/"
  end

  def default_url(version, {%Waffle.File{path: "./mnt/hls/live/" <> file_path}, _scope}) do
    [transmission_uuid, _file] = String.split(file_path, "/")
    "/transmissions/#{transmission_uuid}/#{version}-default.png"
  end

  def default_url(version, {_file, %Transmission{uuid: transmission_uuid}}),
    do: "/transmissions/#{transmission_uuid}/#{version}-default.png"
end
