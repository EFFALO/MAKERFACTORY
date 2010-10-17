require 'spec_helper'

describe UsersController do
  describe "#new" do
    it "should have a new user" do
      get :new
      assigns[:user].should be_new_record
    end
    
    it "should not allow logged in users" do
      user = Factory.create :user
      login_as! user
      get :new
      response.should_not be_success
    end
  end
  
  describe "#create" do
    it "should build a new user for valid params" do
      user = {
        :email => "felixl@gti.biz",
        :name => "Larry Felix",
        :location => "Savannah, Georgia",
        :password => "password",
        :password_confirmation => "password",
        :url => "http://www.effalo.com",
        :description => "Hello, I am a nice fellow, with moods, desires, and feelings."
      }
      post :create, :user => user
      assigns[:user].should be_valid
      assigns[:user].email.should == user[:email]
      response.should redirect_to(account_url)
    end
    
    it "should not allow logged in users" do
      user = Factory.create :user
      login_as! user
      post :create, :user => {}
      response.should_not be_success
    end
  end
  
  describe "#show" do
    before(:each) do
      @user = Factory(:user)
    end
    
    it "should allow anonymous users to get profiles" do
      get :show, :id => @user.id
    end
  end
  
  describe "#edit" do
    before(:each) do
      @user = Factory(:user)
    end
    
    it "should let you edit yoself" do
      login_as! @user
      get :edit
      assigns[:user].should == @user
    end
    
    it "shouldn't let you edit yoself if'n you ain't logged in" do
      get :edit
      assigns[:user].should be_nil
      response.should redirect_to(login_path)
    end
  end
  
  describe "#update" do
    before(:each) do
      @user = Factory(:user)
      @new_name = @user.name + 'Harry'
    end
    
    it "should update yo stuff" do
      login_as! @user
      put :update, :user => {:name => @new_name}
      assigns[:user].name == @new_name
      response.should redirect_to(account_url)
    end
    
    it "shouldn't let you update yoself if'n you ain't logged in" do
      put :update, :user => {:name => @new_name}
      assigns[:user].should be_nil
      response.should redirect_to(login_path)
    end
  end

  describe "#active" do
    before(:each) do
      @user = Factory.create(:user)
      login_as! @user
    end

    it "should allow users with bids and jobs to access the page" do
      Factory.create(:job, :creator => @user)
      Factory.create(:bid, :creator => @user)
      get :active
      response.should be_success
    end

    it "should not allow a user without bids or jobs to access the page" do
      get :active
      response.should_not be_success
    end

    it "should allow the user to access the page if he has jobs" do
      Factory.create(:job, :creator => @user)
      get :active
      response.should be_success
    end

    it "should allow the user to access the page if he has bids" do
      Factory.create(:bid, :creator => @user)
      get :active
      response.should be_success
    end

    it "should not allow anonymous users" do
      logout!
      get :active
      response.should_not be_success
    end
  end
end
