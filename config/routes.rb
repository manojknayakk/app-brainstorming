Rails.application.routes.draw do
  get 'notes/get_roles', to: 'notes#get_roles'
  resources :notes
  resources :users
  post 'authenticate', to: 'authentication#authenticate'
  post 'users/is_valid', to: 'users#is_valid'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
