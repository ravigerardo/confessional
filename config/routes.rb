Rails.application.routes.draw do
  root 'users#show'

  devise_for :users
  get '/:username', to: 'users#show', as: :user
end
