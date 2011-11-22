Plague::Application.routes.draw do
  match '/auth/:provider/callback', to: 'sessions#create'
  resource :session, only: :destroy

  resources :comments, only: [:index, :create, :destroy] do
    member do
      post :publish
      post :answer
    end
  end

  match '/posts.atom',   to: 'posts#feed', format: [:atom]
  match '/posts',        to: 'posts#all'
  match '/posts/update', to: 'posts#update'
  root to: 'posts#title'

  match '*path', to: 'posts#show'
end
