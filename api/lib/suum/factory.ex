defmodule Suum.Factory do
  use ExMachina.Ecto, repo: Suum.Repo
  alias Suum.Accounts.User

  def user_factory do
    %User{
      email: Faker.Internet.email(),
      hashed_password: Bcrypt.hash_pwd_salt("password")
    }
  end
end
