authorization do
  #role :guest do
  #  has_permission_on :controller, :to => [:index, :show ]
  #end
  
  #role :user do
  #  has_permission_on [:users], :to => [:edit, :update, :destroy] do
  #    if_attribute :id => is {user}
  #  end
  #end

  #role :admin do
  #  has_permission_on :users, :to => [:index, :show, :new, :create, :edit, :update, :destroy]
  #end
end
