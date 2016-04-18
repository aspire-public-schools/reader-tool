ReaderTool::Application.routes.draw do

  root to: 'observation_reads#index'

  resource :sessions, only: [:new, :create, :destroy]
  get 'login'     => 'sessions#new',     as: 'login'
  delete 'logout' => 'sessions#destroy', as: 'logout'
  get 'logout'    => 'sessions#destroy', as: 'logout'

  resources :observation_reads, only: [:index, :show, :update] do
    resources :indicator_scores, only: [:update]  
  end

  resources :indicator_scores, only: [] do
    resources :evidence_scores, only: [:index] do
      get :score, on: :collection
    end
  end

  # TODO: password protect this with HTTP auth
  namespace :admin do
    get '', to: 'dashboard#index', as: '/'
    resources :readers, except: [:destroy] do
      member do
        put :deactivate
      end
    end

    resource :observation_reads, only: [:index, :update] do
      collection do
        get :index
      end
    end

    resource :certification_teachers, only: [:index, :update] do
      collection do
        get :index
      end
    end
  end
  match 'admin/readers/:id' => 'admin/readers#edit'

  resources :password_resets

end
