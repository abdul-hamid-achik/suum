# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Suum.Repo.insert!(%Suum.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

import Suum.Factory

insert(:user, email: "abdulachik@gmail.com")
insert_list(15, :transmission)
