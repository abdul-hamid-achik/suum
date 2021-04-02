defmodule SuumWeb.UploadController do
  use SuumWeb, :controller
  use Tus.Controller
  require Logger

  # start upload file callback
  def on_begin_upload(file_info) do
    IO.inspect(file_info)
    Logger.info("create file: #{inspect(file_info)}")
    :ok
  end

  # Completed upload file callback
  def on_complete_upload(file_info) do
    Logger.info("complete file: #{inspect(file_info)}")
  end
end
