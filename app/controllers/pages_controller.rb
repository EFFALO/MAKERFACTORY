class PagesController < ApplicationController
  
  def home
    authorize! :access, :home
    @page_title = 'makerfactory'
    @map_jobs = Job.active.order('created_at DESC').where('lat IS NOT NULL').limit(25)
    @recent_jobs =  @map_jobs.limit(10)
  end
  
end
