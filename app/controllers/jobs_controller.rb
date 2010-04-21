class JobsController < ApplicationController
  def index
    @jobs = Job.find(:all, :limit => 10, :order => "created_at DESC")
  end

  def show
    @job = Job.find(params[:id])
  end

  def new
    @job = Job.new
  end

  def create
    @job = Job.new(params[:job].merge(:creator => current_user))
    if @job.save
      flash[:notice] = "Job successfully created!"
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
      redirect_to(job_path(@job))
    else
      flash[:error] = "Sorry couldn't do that!"
      render :action => :edit
    end
  end

end
