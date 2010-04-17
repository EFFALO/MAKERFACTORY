ActionController::Routing::Routes.draw do |map|
  map.resource :account, :controller => "users"
  map.resource :user_session
  
  # Resources
  map.resources :password_resets
  map.resources :users
  map.resources :jobs
  
  map.login 'login', :controller => "user_sessions", :action => "new"
  map.logout 'logout', :controller => "user_sessions", :action => "destroy"
  map.register 'register', :controller => "users", :action => "new"
  map.root :controller => "pages", :action => "home"
  map.pages 'pages/:action', :controller => "pages"
end
