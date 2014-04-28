ReaderTool::Application.routes.draw do

  root to: 'saml#index'

  resources :saml
  resources :readers, only: [:index, :create, :update]
  resources :sessions, only: [:create, :destroy]
  resources :observations do
    resources :domains do
      resources :indicators do
       resources :evidences do
          get :score, on: :collection
        end
      end
    end
  end

  match '/logout', to: 'sessions#destroy', via: 'delete'
  get 'login' => 'saml#index', as: 'login'
end
