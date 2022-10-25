Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "companies#index"
  get "/companies", to: "companies#index"
  post "/companies",to: "companies#create"
  get "/companies/new", to: "companies#new", as:"new_company"
  get "/companies/:id/edit", to: "companies#edit", as:"edit_company"
  get "/companies/:id", to: "companies#show", as:"company"
  patch "/companies/:id",to: "companies#update"
  delete "/companies/:id", to: "companies#destroy"
  
  get "/schedule", to: "companies#schedule", as: "schedule"
  post "schedule/create", to: "companies#new_schedule", as:"new_schedule"
  
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  get "/users/edit", to: "users#edit", as: "edit_user"
  patch "/user", to: "users#update", as: "user"
  get "/signin", to: "session#new"
  post "/signin", to: "session#create"
  get "/signout", to: "session#destroy"
end
