# frozen_string_literal: true

Rails.application.routes.draw do
  scope '/api', defaults: { format: 'json' } do
    devise_for :users,
      path: '',
      path_names: {
        sign_in: 'login',
        sign_out: 'logout',
        registration: 'signup'
      },
      controllers: {
        sessions: 'users/sessions',
        registrations: 'users/registrations',
        passwords: 'users/passwords',
        confirmations: 'users/confirmations'
      }
    devise_scope :user do
      get '/profile', controller: 'users/registrations', action: :show
      put '/profile/update', controller: 'users/registrations', action: :update_profile
      put '/confirmation' => 'users/confirmations#update'

      resources :invitations, only: [:index, :update], controller: 'users/invitations'
    end

    resources :tasks, except: [:show, :new, :edit]
    resources :logs, only: [:show, :update]
    resources :notes
    resources :nodes do
      resources :statuses
      resources :categories
      resources :roles
      resources :invitations, only: [:index, :create, :destroy]
      resources :memberships
      resources :comments, except: [:new, :edit]
      collection do
        get 'user_projects' # should probably be moved to the user's controller
      end
    end
    resources :favorites, only: [:index, :create, :destroy]

    post '/tasks/update_order', controller: 'tasks', action: :update_order
  end
end
