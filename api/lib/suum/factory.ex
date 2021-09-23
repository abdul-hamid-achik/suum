defmodule Suum.Factory do
  use ExMachina.Ecto, repo: Suum.Repo
  alias Suum.{Accounts.User, Hls.Transmission, Hls.Segment}

  def user_factory do
    %User{
      email: Faker.Internet.email(),
      hashed_password: Bcrypt.hash_pwd_salt("password")
    }
  end

  def transmission_factory do
    name = Faker.Lorem.Shakespeare.En.romeo_and_juliet()

    %Transmission{
      name: name,
      user: build(:user),
      slug: Slugy.slugify(name),
      presigned_preview_url: Faker.Avatar.image_url(),
      type: :vod
    }
  end

  def segment_factory do
    %Segment{
      file_url: Faker.File.file_name(),
      timestamp: Timex.now(),
      duration: 1000,
      transmission: build(:transmission)
    }
  end
end
