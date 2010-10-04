require 'spec_helper'

describe BidsController do

  before(:each) do
    @user = Factory.create(:user)
    @bid = Factory.create(:bid, :creator => @user)
    login_as! @user
  end

  describe "#index" do
    it "should be successful" do
      get :index
      assigns(:bids).should == [@bid]
      response.should be_success
    end
    
    it "should only get the 10 most recent bids" do
      old_bids = 10.times.map { Factory.create(:bid) }
      new_bids = 10.times.map { Factory.create(:bid, :created_at => Time.now + 1.week) }
      get :index
      assigns[:bids].to_set.should == new_bids.to_set
    end
  end

  describe "#show" do
    it "should be successful" do
      get :show, :id => @bid.id
      assigns[:bid].should == @bid
      response.should be_success
    end
    
    it "should have a new bid available" do
      get :show, :id => @bid.id
      assigns[:bid].should be_a(Bid)
    end
  end

  describe "#create" do
    it "should make a new bid with a creator" do
      job = Factory.create(:job)
      post :create, :bid => Factory.attributes_for(:bid, :job => job)
      bid = assigns[:bid]
      bid.should be_valid
      bid.creator.should == @user
      response.should redirect_to job_url(job)
    end
  end

  describe "#edit" do
    it "should not be successful" do
      get :edit, :id => @bid.id
      response.should_not be_success
    end
  end

  describe "#update" do
    it "should not update yo bidz" do
      bid = {:message => "new_mesage"}
      put :update, :id => @bid.id , :bid => bid
      response.should_not be_success
    end
  end


end
