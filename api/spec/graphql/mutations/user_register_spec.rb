require 'rails_helper'

describe 'UserLogout', type: :request do
  before do
    user = create :user, email: 'test@mutation.com'
    query = <<~GQL
      mutation UserRegister(
        $email: String!
        $password: String!
        $passwordConfirmation: String!
        $confirmUrl: String!
      ) {
        userRegister(
        email: $email
        password: $password
        passwordConfirmation: $passwordConfirmation
        confirmUrl: $confirmUrl
      ) {
          credentials {
            accessToken
            client
            expiry
            tokenType
            uid
          }
          authenticatable {
            email
          }
        }
      }
    GQL
    variables = attributes_for :user
    post graphql_path, params: { query: query, variables: variables }
  end

  it 'should create user'
end
