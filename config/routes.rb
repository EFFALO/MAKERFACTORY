ActionController::Routing::Routes.draw do |map|
  map.resource :account, :controller => "users"
  map.resource :user_session
  
  # Resources
  map.resources :password_resets
  map.resources :users, :only => :show
  map.resources :jobs do |jobs|
    jobs.resources :bids, :collection => {:award => :post}
  end
  
  map.login 'login', :controller => "user_sessions", :action => "new"
  map.logout 'logout', :controller => "user_sessions", :action => "destroy"
  map.register 'register', :controller => "users", :action => "new"
  map.active 'active', :controller => "users", :action => "active"
  map.root :controller => "pages", :action => "home"
  map.pages 'pages/:action', :controller => "pages"
end
