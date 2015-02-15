Rails.application.routes.draw do
  resources :posts
  get '/authors/autocomplete'
  get '/categories/autocomplete'
end
