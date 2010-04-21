require 'spec_helper'

describe UsersController do
  describe "#new" do
    it "should have a new user" do
      get :new
      assigns[:user].should be_new_record
    end
  end
  
  describe "#create" do
    it "should build a new user for valid params" do
      user = {
        :email => "felixl@gti.biz",
        :name => "Larry Felix",
        :location => "Savannah, Georgia",
        :password => "password",
        :password_confirmation => "password"
      }
      post :create, :user => user
      assigns[:user].should be_valid
      assigns[:user].email.should == user[:email]
      response.should redirect_to(account_url)
    end
  end
  
  describe "#edit" do
    before(:each) do
      @user = Factory(:user)
    end
    
    it "should let you edit only yoself" do
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
end
