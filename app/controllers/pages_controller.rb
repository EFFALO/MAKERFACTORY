class PagesController < ApplicationController
  
  def home
    authorize! :access, :home
    @page_title = 'makerfactory'
  end
  
end
