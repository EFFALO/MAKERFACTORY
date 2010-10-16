require 'spec_helper'

describe BidsController do

  before(:each) do
    @user = Factory.create(:user)
    @bid = Factory.create(:bid, :creator => @user)
    login_as! @user
  end

  describe "#index" do
    it "should be successful" do
      job = Factory.create(:job, :creator => @user)
      bid = Factory.create(:bid, :job => job)
      get :index, :job_id => job.id
      assigns(:bids).should == [bid]
      response.should be_success
    end
    
    it "should fail for job non-owners" do
      logout!
      login_as! Factory.create(:user)
      get :index, :job_id => @bid.job.id
      response.should_not be_success
    end
  end

  describe "#create" do
    it "should make a new bid with a creator" do
      job = Factory.create(:job)
      post :create, :bid => Factory.attributes_for(:bid), :job_id => job.id
      bid = assigns[:bid]
      bid.should be_valid
      bid.creator.should == @user
      response.should redirect_to job_url(job)
    end
    
    it "should not allow anonymous users" do
      logout!
      job = Factory.create(:job)
      post :create, :bid => Factory.attributes_for(:bid), :job_id => job.id
      response.should redirect_to(login_url) 
    end
  end

  describe "#award" do
    it "should set a bid to awarded" do
      job = Factory.create(:job, :creator => @user)
      bid = Factory.create(:bid, :job => job)
      post :award, :job_id => job.id, :id => bid.id
      response.should redirect_to(job_bids_url(:job_id => job.id))
      bid.reload.awarded.should be_true
    end
    
    it "should disallow anonymous users" do
      logout!
      post :award, :job_id => @bid.job.id, :id => @bid
      response.should redirect_to(login_url)
    end
  end

end
