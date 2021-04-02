import Suum.Factory

root = insert(:user, email: "abdulachik@gmail.com")
insert_list(3, :transmission, user: root) |> IO.inspect()
