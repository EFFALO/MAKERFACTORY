class UsersController < ApplicationController
  load_and_authorize_resource :except => [:edit, :update, :tracker, :count_jobs_bids]

  def new
    @user = User.new
    @page_title = "Create Account"
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Account registered!"
      redirect_back_or_default account_url
    else
      render :action => :new
    end
  end
  
  def show
    # This handles both singular (account) and plural (users) resource.
    @user = User.find(params[:id]) if params[:id]
    @user ||= current_user
    @page_title = "#{@user.name} details"
  end

  def edit
    @user = current_user
    authorize! :update, @user
    if @user
      @page_title = "Edit #{@user.name}"
    else
      flash[:notice] = "Unauthorized request! Gadzooks!"
      redirect_to login_path
    end
  end
  
  def update
    @user = current_user
    authorize! :update, @user
    return redirect_to(login_path) unless @user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end
  
  def tracker
    authorize! :access, :users_tracker
    @user = current_user
    @active_jobs = Job.active.find(:all, :conditions => ["creator_id = ?", current_user.id])
    @inactive_jobs = Job.inactive.find(:all, :conditions => ["creator_id = ?", current_user.id])
    @bids = current_user.bids
  end

end
