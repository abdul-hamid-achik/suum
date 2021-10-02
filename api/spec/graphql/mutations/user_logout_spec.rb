require 'rails_helper'

describe 'UserLogout', type: :request do
  before do
    user = create :user, email: 'test@mutation.com'
    query = <<~GQL
      mutation UserLogout {
        userLogout {
          authenticatable {
            email
          }
        }
      }
    GQL
    variables = { email: 'test@mutation.com', password: '12345678' }
    post graphql_path, params: { query: query, variables: variables }
  end

  it 'should expire token successfully'
end
