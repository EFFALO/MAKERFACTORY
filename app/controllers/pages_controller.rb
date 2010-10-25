class PagesController < ApplicationController
  
  def home
    authorize! :access, :home
    @page_title = 'makerfactory'
    @map_jobs = Job.active
    @recent_jobs = Job.active.find(:all, :limit => 10, :order => 'created_at DESC')
  end
  
end
