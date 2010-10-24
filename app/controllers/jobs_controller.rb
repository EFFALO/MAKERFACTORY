class JobsController < ApplicationController
  load_and_authorize_resource
  
  def index
    @jobs = Job.find(:all, :limit => 10, :order => "created_at DESC")
  end

  def show
    @job = Job.find(params[:id])
    @existing_bid = Bid.find(:first, :conditions => {:job_id => @job.id, :creator_id => current_user.id}) if current_user
    @bid = Bid.new(:job => @job)
  end

  def new
    @job = Job.new
  end

  def create
    @job = Job.new(params[:job].merge(:creator => current_user))
    if @job.save
      flash[:notice] = "Job successfully created!"
      if !@job.lat && !@job.lng
        flash[:notice] = "We created your job but couldn't find its location on a map. Please edit your job if you want it to be on the map."
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
        flash[:notice] = "We altered your job but couldn't find its location on a map. Please edit your job again if you want it to be on the map."
      end
      redirect_to(job_path(@job))
    else
      flash[:error] = "Sorry couldn't do that!"
      render :action => :edit
    end
  end

end
