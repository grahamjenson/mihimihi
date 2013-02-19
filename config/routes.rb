Mihimihi::Application.routes.draw do
  devise_for :users

  namespace :admin do
    resources :events
  end
  resources :events, :only => [:index]
  root :to => 'public#mihimihi'
end
