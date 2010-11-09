MAKERFACTORY::Application.routes.draw do
  resource :user_session
  resources :password_resets
  resources :users
  resource :account, :controller => :users
  resources :jobs do
  resources :bids do
      collection do
        post :award
      end
    end
  end

  match 'login' => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout
  match 'register' => 'users#new', :as => :register
  match 'tracker' => 'users#tracker', :as => :tracker
  match '/' => 'pages#home', :as => :root
  match 'pages/:action' => 'pages#index', :as => :pages
  match 'latest_jobs' => 'jobs#feed', :as => :job_feed
end

