require 'rails_helper'

describe 'UserLogin', type: :request do
  before do
    user = create :user, email: 'test@mutation.com'
    query = <<~GQL
      mutation UserLogin($email: String!, $password: String!) {
        userLogin(email: $email, password: $password) {
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
    variables = { email: 'test@mutation.com', password: '12345678' }
    post graphql_path, params: { query: query, variables: variables }
  end

  it 'should have key userLogin' do
    json_response = JSON.parse(response.body)
    data = json_response['data']
    expect(data).to have_key('userLogin')
  end

  it 'should have key credentials' do
    json_response = JSON.parse(response.body)
    data = json_response['data']['userLogin']
    expect(data).to have_key('credentials')
  end

  it 'should have field authenticable under userLogin' do
    json_response = JSON.parse(response.body)
    data = json_response['data']['userLogin']
    expect(data).to have_key('authenticatable')
  end
end
