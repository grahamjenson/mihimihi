Mihimihi::Application.routes.draw do
  namespace :admin do
    resources :events
  end

  root :to => 'public#mihimihi'
end
