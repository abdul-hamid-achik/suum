Rails.application.routes.draw do
  mount_graphql_devise_for(User, { at: 'admin' })
  mount GraphiQL::Rails::Engine, at: '/graphiql', graphiql_path: 'graphql#execute' if Rails.env.development?
  mount Shrine.presign_endpoint(:cache) => '/s3/params'

  post '/graphql', to: 'graphql#execute'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
