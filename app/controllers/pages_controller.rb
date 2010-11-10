class PagesController < ApplicationController
  
  def home
    authorize! :access, :home
    @page_title = 'makerfactory'
    @map_jobs = Job.active.find(:all, :order => 'created_at DESC', :conditions => 'lat IS NOT NULL')
    @recent_jobs =  @map_jobs.slice(0,10)
  end
  
end
