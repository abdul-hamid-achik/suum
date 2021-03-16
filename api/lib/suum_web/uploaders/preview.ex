defmodule Suum.Uploaders.Preview do
  use Waffle.Definition
  use Waffle.Ecto.Definition
  require Logger
  alias Suum.Hls.Transmission

  @acl :public_read
  @versions [:original]

  def validate({file, _}) do
    Path.extname(file.file_name) == ".jpeg"
  end

  def storage_dir(_version, {_file, %Transmission{uuid: transmission_uuid}}),
    do: "/transmissions/#{transmission_uuid}/"

  def default_url(version, {_file, %Transmission{uuid: transmission_uuid}}),
    do: "/transmissions/#{transmission_uuid}/#{version}-preview-default.jpeg"
end
