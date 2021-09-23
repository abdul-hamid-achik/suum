defmodule Suum.Hls.Transmissions.ServiceTest do
  use Suum.DataCase, async: true
  use Mimic

  alias Suum.Hls.Transmissions.{Service, Service.State}

  setup do
    transmission = insert(:transmission)
    segments = insert_list(10, :segments)

    [transmission: transmission]
  end

  describe "handle_cast/2 :created" do
    test "should when :vod transmission", %{transmission: transmission} do
      assert {:noreply, %State{segments: nil}} =
               Service.handle_cast(:streaming, %State{transmission: transmission})
    end
  end

  describe "handle_cast/2 :streaming" do
    test "handle_cast/2 :streaming", %{transmission: transmission} do
      assert {:noreply, %State{segments: nil}} =
               Service.handle_cast(:streaming, %State{transmission: transmission})
    end
  end

  describe "handle_cast/2 :uploading", %{transmission: transmission} do
    assert {:noreply, %State{segments: nil}} =
             Service.handle_cast(:uploading, %State{transmission: transmission})
  end

  describe "handle_cast/2 :processing", %{transmission: transmission} do
    assert {:noreply, %State{segments: nil}} =
             Service.handle_cast(:uploading, %State{transmission: transmission})
  end
end
