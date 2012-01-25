Plague::Application.routes.draw do
  match '/auth/:provider/callback', to: 'sessions#create'
  resource :session, only: :destroy

  resources :comments, only: [:index, :create, :destroy] do
    member do
      post :publish
      post :answer
    end
  end

  match '/speakandrelax', to: 'fake_internet#speakandrelax'

  match '/wiki/',      to: 'posts#start'
  match '/wiki/:page', to: 'fake_internet#wiki', as: :wiki

  match '/posts.atom',   to: 'posts#feed', format: [:atom], as: :feed
  match '/posts',        to: 'posts#all'
  match '/posts/update', to: 'posts#update'
  root to: 'posts#title'

  match '/:story', to: 'posts#story'
  match '*path',   to: 'posts#show'
end
