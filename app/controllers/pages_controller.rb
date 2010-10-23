class PagesController < ApplicationController
  
  def home
    authorize! :access, :home
    @page_title = 'makerfactory'
    @map_jobs = Job.all
    @recent_jobs = Job.find(:all, :limit => 10, :order => 'created_at DESC')
  end
  
end
