Rails.application.routes.draw do

  root "static_pages#home"
  get "help" => "static_pages#help"
  get "signup" => "users#new"
  get "login" => "sessions#new"
  post "login" => "sessions#create"
  delete "logout" => "sessions#destroy"

  resources :users do
    resources :user_subjects, only: [:edit, :update]
    resources :user_tasks, only: [:edit, :update]
  end
  resources :courses, only: [:show, :index]
  resources :user_subjects, only: [:edit, :update]
  resources :user_tasks, only: [:edit, :update]

  namespace :admin do
    root  "users#index"
    resources :users
    resources :courses do
      resource :user_courses, only: :show
      get "assign_users" => "user_courses#show"
    end
    resources :subjects
  end
end
