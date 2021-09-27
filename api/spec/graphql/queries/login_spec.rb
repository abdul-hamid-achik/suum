require 'rails_helper'

describe 'Login', type: :request do
  it 'gets a token after' do
    post '/admin', params: { query: query('abdul', 'a') }
    puts response.body

    expect(response).to eq nil
  end

  def query(email, password)
    <<~GQL
      mutation {
        login(
          email: #{email}
          password: #{password}
        ) {
          token
        }
      }
    GQL
  end
end
