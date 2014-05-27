ReaderTool::Application.routes.draw do

  root to: 'readers#index'

  namespace :admin do
    get '', to: 'dashboard#index', as: '/'
    resources :readers, only: [:index, :create, :show, :edit, :new]
    resources :observations
    put 'observations_updates', to: 'observations#update'
  end

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

  get 'login' => 'readers#index', as: 'login'
end
