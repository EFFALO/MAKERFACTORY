class BidsController < ApplicationController
  load_and_authorize_resource :job, :except => [:accept, :index]
  load_and_authorize_resource :bid, :through => :job, :except => [:accept, :index]
  
  def create
    @bid = Bid.new(params[:bid].merge(:creator => current_user, :job => @job))
    if request.xhr?
      if @bid.save
        render :json => {
          :partial => render_to_string('jobs/_current_user_bid.html.haml', :locals => {:bid => @bid})
        }
      else
        render :json => {:errors => @bid.errors}
      end
      return
    else
      redirect_to :controller => :jobs, :action => :show, :id => @bid.job.id
    end
  end
  
  def award
    @bid = Bid.find(params[:id])
    authorize! :award, @bid
    @bid.award!
    redirect_to :controller => :jobs, :action => :show, :id => @bid.job.id
  end

end
