defmodule Suum.ProjectsTest do
  use Suum.DataCase

  alias Suum.Projects

  describe "two_cameras" do
    alias Suum.Projects.TwoCameras

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def two_cameras_fixture(attrs \\ %{}) do
      {:ok, two_cameras} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Projects.create_two_cameras()

      two_cameras
    end

    test "list_two_cameras/0 returns all two_cameras" do
      two_cameras = two_cameras_fixture()
      assert Projects.list_two_cameras() == [two_cameras]
    end

    test "get_two_cameras!/1 returns the two_cameras with given id" do
      two_cameras = two_cameras_fixture()
      assert Projects.get_two_cameras!(two_cameras.id) == two_cameras
    end

    test "create_two_cameras/1 with valid data creates a two_cameras" do
      assert {:ok, %TwoCameras{} = two_cameras} = Projects.create_two_cameras(@valid_attrs)
    end

    test "create_two_cameras/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Projects.create_two_cameras(@invalid_attrs)
    end

    test "update_two_cameras/2 with valid data updates the two_cameras" do
      two_cameras = two_cameras_fixture()
      assert {:ok, %TwoCameras{} = two_cameras} = Projects.update_two_cameras(two_cameras, @update_attrs)
    end

    test "update_two_cameras/2 with invalid data returns error changeset" do
      two_cameras = two_cameras_fixture()
      assert {:error, %Ecto.Changeset{}} = Projects.update_two_cameras(two_cameras, @invalid_attrs)
      assert two_cameras == Projects.get_two_cameras!(two_cameras.id)
    end

    test "delete_two_cameras/1 deletes the two_cameras" do
      two_cameras = two_cameras_fixture()
      assert {:ok, %TwoCameras{}} = Projects.delete_two_cameras(two_cameras)
      assert_raise Ecto.NoResultsError, fn -> Projects.get_two_cameras!(two_cameras.id) end
    end

    test "change_two_cameras/1 returns a two_cameras changeset" do
      two_cameras = two_cameras_fixture()
      assert %Ecto.Changeset{} = Projects.change_two_cameras(two_cameras)
    end
  end
end
