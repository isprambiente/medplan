# frozen_string_literal: true

Rails.application.routes.draw do
  localized do
    devise_for :users, path: 'auth', path_names: { sign_in: 'login', sign_out: 'logout' }
    root 'home#index'

    get 'home/index', to: 'home#index', as: :home_index
    get 'home/list', to: 'home#list', as: :home_list
    get 'home/user' => 'home#user'
    get 'home/report' => 'home#report'
    post 'home/report' => 'home#report'
    get 'home/meetings' => 'home#meetings', as: :home_meetings
    post 'home/update_user' => 'home#update_user'
    put 'home/reset_password', to: 'home#reset_password', as: :reset_password

    resources :users, except: %i[index edit] do
      get :index, on: :collection, to: 'users#index'
      get :list, on: :collection, to: 'users#list'
      put   :notify, on: :member
      patch :unlock, on: :member
      get   :edit_external, on: :member, to: 'users#edit_external_user'
      get   :external, on: :member, to: 'users#external_user'
      post  :external, on: :member, to: 'users#external_user'
      put   :external, on: :member, to: 'users#external_user'
      get   :user,     on: :member, to: 'users#user'
      delete :delete_attachment, on: :member, to: 'users#remove_attachment', as: :delete_attachment
      resources :audits, except: %i[show new]
      resources :events, only: %i[new create meeting_destroy reserve confirmed] do
        put 'reserve'
        put :confirmed, on: :member, to: 'events#confirmed'
        put :meeting_sendmail, to: 'events#meeting_sendmail'
        delete :meeting_destroy, to: 'events#meeting_destroy'
      end
    end

    resources :events, except: %i[new create update reserve meeting_destroy confirmed] do
      get :meetings, on: :collection
      put :print, on: :collection
      get :agenda, on: :collection
      put :confirmed_users, on: :member, to: 'events#confirmed_users'
    end
    resources :categories, except: [:show]
    resources :risks, except: [:show]
  end
end
