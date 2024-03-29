Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "homepage#index"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    get 'auth/google_oauth2/callback', to: 'sessions#google_login'
    resource :users, except: :destroy do
      member do
        get :change_password
        patch :update_change_password
        get :google_registration
      end
    end
    resources :account_activations, only: :edit
    resources :password_resets, except: [:index, :show, :destroy]
    resources :jobs, only: [:show, :index] do
      member do
        put :apply
        delete :close
      end
    end
    resources :institutions, only: [:show, :update] do
      member do
        get :info, :jobs, :users
        patch :fire
        put :apply
        delete :close
      end
    end
    resources :create_cvs, only: [:show, :new, :create]
    resources :scan_cvs, only: [:show, :new, :create]

    namespace :recruiter do
      resources :institutions, except: [:index, :show, :destroy]
      resources :jobs, except: [:show, :destroy] do
        member do
          get :cvs
          patch :close
        end
      end
      resources :curriculum_vitaes, only: :show do
        member do
          patch :send_email
        end
      end
      resources :callings, only: :show
    end

    namespace :candidate do
      resources :curriculum_vitaes, except: [:destroy] do
        member do
          get :applied
          delete :close
        end
      end
      resources :callings, only: :show
    end

    namespace :admin do
      resources :jobs, only: [:index, :update] do
        member do
          patch :open
        end
      end
      resources :users, only: :index do
        member do
          patch :active, :block
        end
      end
      resources :fields, except: [:new, :show, :edit]
    end
  end
end
