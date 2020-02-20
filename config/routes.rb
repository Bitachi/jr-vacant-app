Rails.application.routes.draw do
  get 'users/new'
  root "static_pages#home"
  get '/help', to: "static_pages#help"
  get "/about", to: "static_pages#about"
  # For details on the DSL av ailable within this file, see http://guides.rubyonrails.org/routing.html
  get "/signup", to: "users#new"
end
