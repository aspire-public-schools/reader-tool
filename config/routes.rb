ReaderTool::Application.routes.draw do

  root to: 'saml#index'

  namespace :admin do
    get '', to: 'dashboard#index', as: '/'
    resources :readers do
      member do
        put :deactivate
      end
    end
    resources :observations
    put 'observations_updates', to: 'observations#update'
  end

  resources :saml
  resources :readers, only: [:index, :create, :update, :new]
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

  match 'admin/readers/:id' => 'admin/readers#edit'
  match '/logout', to: 'sessions#destroy', via: 'delete'
  get 'login' => 'saml#index', as: 'login'
end
