Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'videos#index'

  resources :videos do
    resources :reactions, only: :destroy do
      collection do
        post :like
        post :dislike
      end
    end
  end
end
