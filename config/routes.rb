Rails.application.routes.draw do
  root 'users/profiles#show'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  namespace :users do
    patch '/profile', to: 'profiles#edit'
  end

  get '/:username', to: 'users/profiles#show', as: :user
end
