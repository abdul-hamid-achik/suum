defmodule Suum.Uploaders.Thumbnail do
  use Waffle.Definition
  use Waffle.Ecto.Definition
  require Logger
  alias Suum.Hls.Thumbnail

  @acl :public_read
  @versions [:original]

  def validate({file, _}) do
    Path.extname(file.file_name) == ".jpeg"
  end

  def storage_dir(_version, {_file, %Thumbnail{transmission_uuid: transmission_uuid}}),
    do: "/transmissions/#{transmission_uuid}/thumbnails/"

  def storage_dir(_version, {%Waffle.File{path: "./mnt/hls/live/" <> file_path}, _scope}) do
    [transmission_uuid, _file] = String.split(file_path, "/")
    "/transmissions/#{transmission_uuid}/thumbnails/"
  end

  def default_url(version, {%Waffle.File{path: "./mnt/hls/live/" <> file_path}, _scope}) do
    [transmission_uuid, _file] = String.split(file_path, "/")
    "/transmissions/#{transmission_uuid}/thumbnails/#{version}-default.jpeg"
  end

  def storage_dir(_version, {%Waffle.File{path: "./mnt/uploads/" <> file_path}, _scope}) do
    [transmission_uuid, _file] = String.split(file_path, "/")
    "/transmissions/#{transmission_uuid}/thumbnails/"
  end

  def default_url(version, {%Waffle.File{path: "./mnt/uploads/" <> file_path}, _scope}) do
    [transmission_uuid, _file] = String.split(file_path, "/")
    "/transmissions/#{transmission_uuid}/thumbnails/#{version}-default.jpeg"
  end

  def default_url(version, {_file, %Thumbnail{transmission_uuid: transmission_uuid}}),
    do: "/transmissions/#{transmission_uuid}/thumbnails/#{version}-default.jpeg"
end
