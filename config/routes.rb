ActionController::Routing::Routes.draw do |map|
  map.resource :account, :controller => "users"
  map.resource :user_session
  
  # Resources
  map.resources :password_resets, :only => [:new, :create, :edit, :update]
  map.resources :users, :only => :show
  map.resources :jobs, :member => {:delete_image => :put} do |jobs|
    jobs.resources :bids,
      :collection => {:award => :post},
      :except => [:index]
  end
  
  map.login 'login', :controller => "user_sessions", :action => "new"
  map.logout 'logout', :controller => "user_sessions", :action => "destroy"
  map.register 'register', :controller => "users", :action => "new"
  map.tracker 'tracker', :controller => "users", :action => "tracker"
  map.root :controller => "pages", :action => "home"
  map.pages 'pages/:action', :controller => "pages"
  map.job_feed 'latest_jobs', :controller => "jobs", :action => "feed"
end
