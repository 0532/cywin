Rails.application.routes.draw do

  resources :timeline, only: [:index]

  namespace :settings do
    resource :profile, only: [:show, :update]
    resource :password, only: [:show, :update]
    resource :notification, only: [:show, :update]
  end

  devise_for :users, :controllers => {:registrations => "registrations", :omniauth_callbacks => "authentications"}
  resources :users, only: [:show] do
    collection do
      get :autocomplete
      post :email_validate
    end

    scope module: 'users' do
      resources :projects, only: [:index]
      resources :invitements, only: :index
      resources :funs, only: :index
      resource :activities, only: :show
    end
  end
  
  resources :delivering_projects, only: [:index, :create]

  resources :stars, only: [:create] do 
    collection do
      delete :destroy
    end
  end

  resources :events, only: [:index]

  resources :funs, only: [:create] do
    collection do
      delete :destroy
    end
  end

  resources :talks, only: [:create] do
    collection do
      get :talk_content
    end
  end

  resources :about do
    collection do
      get :index
      get :partner
      get :service
      get :law
      get :job
      get :venture
      get :guide
    end
  end
  resources :refine
  resources :categories do
    collection do
      get :autocomplete
    end
  end
  resources :cities do
    collection do
      get :autocomplete
    end
  end

  resources :explore do
    collection do
      get :all
      get :categories
      get :trend
      get :search
    end
  end

  resources :syndicates
  resources :investments, only: [:index, :create]

  resources :interest_users, only: [:index]
  resources :jobs, only: [:index] do
    collection do
      get :search
    end
  end

  resources :logos, only: [:create]
  resources :screenshots, only: [:create]
  resources :projects, except: [:index] do
    member do
      post :publish
      post :invite
      get :team
      get :invest
      patch :dirty_update
      patch :screenshots_update
    end
    resources :members do
      collection do
        get :owner
        get :team_story
        post :update_team_story
        get :autocomplete
        post :invite
      end
    end

    resources :person_requires do
      collection do
        get :admin
      end

      member do
        patch :close
        patch :open
        post :interest
      end
    end
  end

  resources :investors do
    collection do
      get :autocomplete
      get :search
      get :basic
      get :idea
      get :prove
      get :info
      post :submit
    end
  end

  resources :investideas, only: [:index, :create]
  resources :cards, only: [:index, :create]
  resources :bank_statements, only: [:index, :create]

  resources :money_requires do
    member do
      post :add_leader
      patch :add_leader
      post :leader_reject
      patch :leader_reject
      post :leader_confirm
      patch :leader_confirm
      post :close
      patch :close
      patch :dirty_update
    end
    collection do
      post :dirty_create
      get :dirty_show
      get :opened
      get :history
      get :admin
    end
  end

  resources :messages, only: [:index] do
    collection do
      get :count
    end
  end

  resources :law_iterms do
    collection do
      post :diy
    end
  end

  namespace :admin do
    resources :users
    resources :projects
    resources :investors, only: :index do
      member do
      post :accept
      post :reject
      end
    end
    resources :leaders, only: :index do
      collection do
      post :accept
      post :reject
      end
    end
    resources :recommends
    resources :invite_codes
    resources :law_iterms
    root :to=> "dashboard#index"
  end
  root :to => "home#index"
  resources :home, only: [] do
    collection do
      get :index
      get :welcome
      get :search
    end
  end
  resources :avatars, only: [:create]
  resources :messages
  resources :conversations, only: [:index ] do
    member do
      post :mark_as_read
    end
    collection do
      get :unread_count
    end
  end

  require 'sidekiq/web'
  authenticate :user, lambda { |u| u.has_role?(:admin) } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
