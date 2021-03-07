defmodule Suum.Factory do
  use ExMachina.Ecto, repo: Suum.Repo

  def user_factory do
    %User{
      email: Faker.Internet.email(),
      password_hash: Bcrypt.hash_pwd_salt("password")
    }
  end
end
