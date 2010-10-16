class BidsController < ApplicationController
  load_and_authorize_resource :job, :except => [:accept, :index]
  load_and_authorize_resource :bid, :through => :job, :except => [:accept, :index]
  
  def index
    @job = Job.find(params[:job_id])
    # this authorize is only because we can't get Cancan to play nice with nested resources
    # and indexes
    authorize! :read_bids, @job
    
    @bids = @job.bids
  end

  def create
    @bid = Bid.new(params[:bid].merge(:creator => current_user, :job => @job))
    if @bid.save
      flash[:notice] = "You have just successfully bid ... ed"
      redirect_to job_path(@bid.job)
    else
      @job = @bid.job
      # WE'RE GOING BACK YA'LL CAUSE SHIT AIN'T RIGHT
      render 'jobs/show'
    end
  end
  
  def award
    @bid = Bid.find(params[:id])
    authorize! :award, @bid
    @bid.award!
    redirect_to :action => :index, :job_id => @bid.job.id
  end

end
