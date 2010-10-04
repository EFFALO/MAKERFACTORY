class BidsController < ApplicationController
  load_and_authorize_resource
  
  def index
    @bids = Bid.find(:all, :limit => 10, :order => 'created_at DESC')
  end
  
  def show
    @bid = Bid.find(params[:id])
  end
  
  def create
    @bid = Bid.new(params[:bid].merge(:creator => current_user))
    if @bid.save
      flash[:notice] = "You have just successfully bid ... ed"
      redirect_to job_path(@bid.job)
    else
      @job = @bid.job
      # WE'RE GOING BACK YA'LL CAUSE SHIT AIN'T RIGHT
      render 'jobs/show'
    end
  end
  
  def edit
    @bid = Bid.find(params[:id])
  end
  
  def update
    @bid = Bid.find(params[:id])
    if @bid.update_attributes(params[:bid])
      flash[:notice] = "Bid successfully update ... ed"
      redirect_to bid_path(@bid)
    else
      render :action => :edit
    end
  end
end
