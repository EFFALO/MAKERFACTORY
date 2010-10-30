require 'spec_helper'

describe BidsController do

  before(:each) do
    @user = Factory.create(:user)
    @bid = Factory.create(:bid, :creator => @user)
    login_as! @user
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
      lambda { 
        post :create, :bid => Factory.attributes_for(:bid), :job_id => job.id
      }.should_not change(Bid, :count)
      # We would love to do this, testing current_user in authlogic after logout! doesn't seem to work.
      # response.should redirect_to(login_url)
    end
  end

  describe "#award" do
    it "should set a bid to awarded" do
      job = Factory.create(:job, :creator => @user)
      bid = Factory.create(:bid, :job => job)
      post :award, :job_id => job.id, :id => bid.id
      response.should redirect_to(job_url(:id => job.id))
      bid.reload.awarded.should be_true
    end
    
    it "should disallow anonymous users" do
      logout!
      post :award, :job_id => @bid.job.id, :id => @bid
      response.should redirect_to(login_url)
    end
  end

end
