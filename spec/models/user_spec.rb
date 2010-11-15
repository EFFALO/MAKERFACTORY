require 'spec_helper'

describe User do
  before(:each) do
    @user = Factory.create(:user)
  end
  
  describe "#received_bid_award_count" do
    before(:each) do
      @job = Factory.create(:job)
      @bid = Factory.create(:bid, :creator => @user, :job => @job)    
    end
    
    it "should return 0 if you had no awarded bids" do
      @user.received_bid_award_count.should == 0
    end
    
    it "should return 1 if you have 1 awarded bid" do
      @bid.award!
      @user.received_bid_award_count.should == 1
    end
    
    it "should return n if you have n awarded bids" do
      @bid.award!
      9.times do 
        job = Factory.create(:job)
        bid = Factory.create(:bid, :creator => @user, :job => job)
        bid.award!
      end
      @user.received_bid_award_count.should == 10
    end
    
    it "should not return bids awarded to other users" do
      other_user = Factory.create(:user)
      other_bid = Factory.create(:bid, :creator => other_user, :job => @job)
      other_bid.award!
      @user.received_bid_award_count.should == 0
    end
  end
  
  describe "#sent_bid_award_count" do
    before(:each) do
      @job = Factory.create(:job, :creator => @user)
      @bid = Factory.create(:bid, :job => @job)
    end
    
    it "should return 0 if you have not awarded bids" do
      @user.sent_bid_award_count.should == 0
    end
    
    it "should return 1 if you have awarded 1 bid" do
      @bid.award!
      @user.sent_bid_award_count.should == 1
    end
    
    it "should return all the awarded bids for one job" do
      other_bid = Factory.create(:bid, :job => @job)
      @bid.award!
      other_bid.award!
      @user.sent_bid_award_count.should == 2
    end
    
    it "should return all the awarded bids across jobs" do
      other_job = Factory.create(:job, :creator => @user)
      other_bid = Factory.create(:bid, :job => other_job)
      @bid.award!
      other_bid.award!
      @user.sent_bid_award_count.should == 2
    end
    
    it "should not include others' awarded bids" do
      other_user = Factory.create(:user)
      other_job = Factory.create(:job, :creator => other_user)
      other_bid = Factory.create(:bid, :job => other_job)
      @user.sent_bid_award_count.should == 0
    end
  end

  describe "add http:// to urls" do
    it "should add http:// to urls if the url needs it" do
      user = Factory.create(:user, :url => "www.makerfactory.com")
      user.url.should == "http://www.makerfactory.com"
    end

    it "should not add http:// to urls if they don't need it" do
      user = Factory.create(:user, :url => "http://www.makerfactory.com")
      other_user = Factory.create(:user, :url => "https://www.makerfactory.com")

      user.url.should == "http://www.makerfactory.com"
      other_user.url.should == "https://www.makerfactory.com"
    end
  end
end
