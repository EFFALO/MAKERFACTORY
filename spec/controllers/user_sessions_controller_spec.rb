require 'spec_helper'

describe UserSessionsController do
  describe "permissions" do
    before(:each) do
      @user = Factory.create :user
    end
    
    it "should let anonymous users login" do
      get :new
      response.should be_success
      
      post :create, :user_session => { :email => @user.email, :password => @user.password }
      response.should be_redirect
      assigns(:user_session).should be_valid
    end
  end
  
  
end
