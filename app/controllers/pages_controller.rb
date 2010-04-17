class PagesController < ApplicationController
  
  def home
    @page_title = 'makerfactory'
  end
  
  def css_test
    @page_title = "CSS Test"
  end
  
end
