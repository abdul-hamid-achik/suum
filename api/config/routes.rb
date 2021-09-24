Rails.application.routes.draw do
  mount_graphql_devise_for 'User', at: 'graphql_auth'
  mount_graphql_devise_for User, at: 'admin'
  
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphiql_path: "graphql#execute"
  end
  
  post "/graphql", to: "graphql#execute"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
