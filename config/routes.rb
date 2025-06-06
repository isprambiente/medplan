# frozen_string_literal: true

Rails.application.routes.draw do
  if RAILS_DEVISE_OMNIAUTHABLE
    devise_for :users, prefix: "auth", controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  else
    devise_for :users, prefix: "auth"
  end
  unless RAILS_DEVISE_DATABASE_AUTHENTICATABLE
    devise_scope :user do
      get "sign_in", to: "users/sessions#new", as:  :new_user_session
      delete "sign_out", to: "devise/sessions#destroy", as: :destroy_user_session
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
  root 'home#index'

  localized do
    get 'home/index', to: 'home#index', as: :home_index
    get 'home/list', to: 'home#list', as: :home_list
    get 'home/user' => 'home#user'
    get 'home/report' => 'home#report'
    post 'home/report' => 'home#report'
    get 'home/meetings' => 'home#meetings', as: :home_meetings
    post 'home/update_user' => 'home#update_user'
    put 'home/reset_password', to: 'home#reset_password', as: :reset_password
    get 'home/export', to: 'home#export', as: :export_home, defaults: { format: :xlsx }


    scope :api do
      get :agenda, to: 'home#user', format: :json
    end

    resources :users, except: %i[index edit] do
      get :index, on: :collection, to: 'users#index'
      get :list, on: :collection, to: 'users#list'
      get :export, on: :collection, to: 'users#export', defaults: { format: :xlsx }
      put   :notify, on: :member
      patch :unlock, on: :member
      get   :edit_external, on: :member, to: 'users#edit_external_user'
      get   :external, on: :member, to: 'users#external_user'
      post  :external, on: :member, to: 'users#external_user'
      put   :external, on: :member, to: 'users#external_user'
      get   :user,     on: :member, to: 'users#user'
      get    :delete_attachment, on: :member, to: 'users#remove_attachment', as: :delete_attachment
      delete :delete_attachment, on: :member, to: 'users#remove_attachment', as: :delete_attachment
      resources :audits, except: %i[show new]
      resources :events, only: %i[new create] do
        put 'reserve'
        put :confirmed, on: :member, to: 'events#confirmed'
        put :meeting_sendmail, to: 'events#meeting_sendmail'
        delete :meeting_destroy, to: 'events#meeting_destroy'
      end
    end

    resources :events, except: %i[new create update] do
      get :meetings, on: :collection
      get :meetings, on: :member
      put :print, on: :collection
      get :agenda, on: :collection
      put :confirmed_users, on: :member, to: 'events#confirmed_users'
    end
    resources :categories, except: [:show] do
      get :list, on: :collection, to: 'categories#list'
    end
    resources :risks, except: [:show] do
      get :list, on: :collection, to: 'risks#list'
    end
  end
end
