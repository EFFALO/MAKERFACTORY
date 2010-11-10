class JobsController < ApplicationController
  load_and_authorize_resource :except => [:delete_image, :feed]

  def index
    @jobs = Job.active.find(:all, :limit => 10, :order => "created_at DESC")
  end

  def show
    @job = Job.find(params[:id])
    @existing_bid = Bid.find(:first, :conditions => {:job_id => @job.id, :creator_id => current_user.id}) if current_user
    if can? :read_bids, @job
      @bids = @job.bids.find(:all, :order => "quantity DESC") if @job.bids
    end
    @bid = Bid.new(:job => @job)
  end

  def new
    @job = Job.new(:deliver_by => 1.week.from_now)
  end

  def create
    @job = Job.new(params[:job].merge(:creator => current_user))
    if @job.save
      flash[:notice] = "Job successfully created!"
      if !@job.lat && !@job.lng
        flash[:notice] = "Job created, but we're unsure of its location (so it won't be on the map)."
      end
      redirect_to job_path(@job)
    else
      render :action => :new
    end
  end

  def edit
    @job = Job.find(params[:id])
  end

  def update
    @job = Job.find(params[:id])
    if @job.update_attributes(params[:job])
      flash[:notice] = "Job successfully altered!"
      if !@job.lat && !@job.lng
        flash[:notice] = "Job updated, but we're unsure of its location (so it won't be on the map)."
      end
      redirect_to(job_path(@job))
    else
      render :action => :edit
    end
  end

  def destroy
    Job.find(params[:id]).destroy
    redirect_to(tracker_path)
  end

  def feed
    @jobs = Job.active.order('id DESC').limit(10)
    render :layout => false
    response.headers["Content-Type"] = "application/xml; charset=utf-8"
  end

end
