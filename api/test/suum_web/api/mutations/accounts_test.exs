defmodule SuumWeb.Schema.Mutations.AccountsTest do
  use SuumWeb.ConnCase
  import Suum.Factory

  @signup_mutation """
  mutation SignupMutation(
    $email: String!
    $password: String!
    $password_confirmation: String!
  ) {
    signup(
      email: $email
      password: $password
      password_confirmation: $password_confirmation
    ) {
      token
      user {
        uuid
        email
      }
    }
  }
  """

  @signin_mutation """
  mutation SigninMutation($email: String!, $password: String!) {
    signin(email: $email, password: $password) {
      token
      user {
        uuid
        email
      }
    }
  }
  """

  setup do
    conn = build_conn()
    [conn: conn]
  end

  describe "`signup` mutation" do
    @tag :wip
    test "should return token and user info", %{conn: conn} do
      assert %{
               "data" => %{
                 "signup" => %{
                   "token" => token,
                   "user" => %{"email" => email, "uuid" => uuid}
                 }
               }
             } =
               conn
               |> post("/api/graphql", %{
                 "query" => @signup_mutation,
                 "variables" => %{
                   email: "abdulachik@gmail.com",
                   password: "password",
                   password_confirmation: "password"
                 }
               })
               |> json_response(200)

      user = Suum.Accounts.get_user!(uuid)
      assert "#{user.uuid}" == uuid
      assert user.email == email
      assert Suum.Accounts.UserToken.verify_session_token_query(token)
    end
  end

  describe "`signin` mutation" do
    @tag :wip
    test "should return token and user info", %{conn: conn} do
      user =
        insert(:user,
          email: "abdulachik@gmail.com"
        )

      assert %{
               "data" => %{
                 "signin" => %{
                   "token" => token,
                   "user" => %{"email" => email, "uuid" => uuid}
                 }
               }
             } =
               conn
               |> post("/api/graphql", %{
                 "query" => @signin_mutation,
                 "variables" => %{
                   email: "abdulachik@gmail.com",
                   password: "password"
                 }
               })
               |> json_response(200)

      assert "#{user.uuid}" == uuid
      assert user.email == email
      assert Suum.Accounts.UserToken.verify_session_token_query(token)
    end
  end
end
