defmodule Suum.Factory do
  use ExMachina.Ecto, repo: Suum.Repo
  alias Suum.{Accounts.User, Hls.Transmission}

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
      preview_url: Faker.Avatar.image_url(),
      type: :vod
    }
  end
end
