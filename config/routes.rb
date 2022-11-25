Rails.application.routes.draw do
  root 'chats#index'
  
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  
  namespace :users do
    patch '/profile', to: 'profiles#edit'
  end
  
  resources :chats, only: %i[ index show create destroy ], param: :uid

  get '/:username', to: 'users/profiles#show', as: :user
end
