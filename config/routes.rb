ReaderTool::Application.routes.draw do

  resources :sessions, only: [:create, :destroy]
  if Rails.env.staging? || Rails.env.development?
    get 'login_as/:eid' => 'sessions#create'
  end

  # TODO: remove saml stuff  
  resources :saml
  get 'login' => 'saml#index', as: 'login'
  delete 'logout' => 'sessions#destroy', as: 'logout'
  root to: 'saml#index'


  resources :readers, only: [:index, :create, :update, :new]

  # TODO fix for only second-level nesting
  # resources :observations do
  #   resources :domains
  # end
  # resources :domains do
  #   resources :indicators
  # end
  # resources :indicators do
  #   resources :evidences do
  #     get :score, on: :collection
  #   end
  # end

  resources :observations do
    resources :domains do
      resources :indicators do
       resources :evidences do
          get :score, on: :collection
        end
      end
    end
  end

  # TODO: password protect this with HTTP auth
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
  match 'admin/readers/:id' => 'admin/readers#edit'

end
