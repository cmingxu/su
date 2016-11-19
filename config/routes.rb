Rails.application.routes.draw do
  get 'welcome/index'

  resources :categories, only: [:index, :show]

  namespace :dashboard do
    get '/' => "base#index"
    get 'base/index'
    get 'setting' => "setting#index"
    resources :categories
    resources :styles
    resources :tags
    resources :entities do
      member do
        patch :toggle_visible
      end
    end
      resources :vendors do
      resources :materials
    end
    resources :materials
    resources :users do
      member do
        patch :toggle_visible
      end
    end
  end

  namespace :plugin do
    get '/' => 'base#index'
  end

  namespace :api, defaults: { format: :json } do
    resources :entities, only: [:index, :create, :destroy] do
      get :mine, on: :collection
        post :remove, on: :collection
    end

    resources :users, only: [:create] do
      post :login, on: :collection
      delete :sign_out, on: :collection
    end
  end

  resource :session, controller: :session
  resource :registration, only: [:new, :create], controller: :registration


  root 'welcome#index'

  # authentication

end
