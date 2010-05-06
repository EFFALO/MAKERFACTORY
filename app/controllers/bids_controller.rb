class BidsController < ApplicationController
  def index
    @bids = Bid.find(:all, :limit => 10, :order => 'created_at DESC')
  end
  
  def show
    @bid = Bid.find(params[:id])
  end
  
  def new
    @bid = Bid.new
  end
  
  def create
    @bid = Bid.new(params[:bid].merge(:creator => current_user))
    if @bid.save
      flash[:notice] = "You have just successfully bid ... ed"
      redirect_to bid_path(@bid)
    else
      render :action => :new
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
