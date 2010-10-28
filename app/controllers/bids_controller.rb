class BidsController < ApplicationController
  load_and_authorize_resource :job, :except => [:accept, :index]
  load_and_authorize_resource :bid, :through => :job, :except => [:accept, :index]
  
  def create
    @bid = Bid.new(params[:bid].merge(:creator => current_user, :job => @job))
    unless @bid.save
      render :json => {:errors => @bid.errors}
    end
  end
  
  def award
    @bid = Bid.find(params[:id])
    authorize! :award, @bid
    @bid.award!
    redirect_to :action => :index, :job_id => @bid.job.id
  end

end
