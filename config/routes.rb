Rails.application.routes.draw do
  root to: 'players#index' 
  resources :players do
    collection do
      get  :chess_match
      post :create_match
    end
  end
end
