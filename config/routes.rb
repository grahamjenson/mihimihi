Mihimihi::Application.routes.draw do
  

  devise_for :users

  namespace :admin do
    resources :events
    resources :image_data
  end
  resources :events, :only => [:index]
  root :to => 'public#mihimihi'
end
