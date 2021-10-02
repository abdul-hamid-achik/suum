Rails.application.routes.draw do
  mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: 'graphql#execute' if Rails.env.development?
  mount Shrine.presign_endpoint(:cache) => '/s3/params'

  post '/graphql', to: 'graphql#execute'
end
