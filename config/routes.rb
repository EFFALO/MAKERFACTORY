ActionController::Routing::Routes.draw do |map|
  map.resource :account, :controller => "users"
  map.resources :password_resets
  map.resources :users
  map.resource :user_session
  map.login 'login', :controller => "user_sessions", :action => "new"
  map.logout 'logout', :controller => "user_sessions", :action => "destroy"
  map.register 'register', :controller => "users", :action => "new"
  map.root :controller => "pages", :action => "home"
  map.pages 'pages/:action', :controller => "pages"
end
