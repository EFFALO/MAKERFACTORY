require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  before(:each) do
    @user = Factory.create(:user)
    @ability = Ability.new(@user)
  end
  
  it "should not allow you to bid on your own jobs" do
    job = Factory.create(:job, :creator => @user)
    bid = Factory.build(:bid, :job => job)
    
    @ability.should_not be_able_to(:create, bid)
  end
  
  it "should not allow you to bid a job more than once" do
    job = Factory.create(:job)
    bid = Factory.create(:bid, :job => job, :creator => @user)
    bid2 = Factory.build(:bid, :job => job, :creator => @user)

    @ability.should_not be_able_to(:create, bid2)
  end
  
  it "should allow you to update only yourself" do
    user2 = Factory.create(:user)
    
    @ability.should_not be_able_to(:update, user2)
    @ability.should be_able_to(:update, @user)
  end

  it "should not let you bid on expired jobs" do
    job = Factory.create(:job, :created_at => 3.weeks.ago - 5.minutes)
    #debugger
    bid = Factory.build(:bid, :job => job, :creator => @user)
    @ability.should_not be_able_to(:create, bid)
  end

  it "should not allow anonymous users to new bids on expired jobs" do
    job = Factory.create(:job, :created_at => 3.weeks.ago)
    bid = Factory.build(:bid, :job => job)
    
    anonymous_ability = Ability.new(nil)
    anonymous_ability.should_not be_able_to(:new, bid)
  end

  it "should allow you to delete your unbidded job" do
    job = Factory.create(:job, :creator => @user)
    @ability.should be_able_to(:destroy, job)
  end

  it "should not allow you to delete a job with bids" do
    job = Factory.create(:job, :creator => @user)
    Factory.create(:bid, :job => job)
    @ability.should_not be_able_to(:destroy, job)
  end

  it "should not allow you to delete another's job" do
    user = Factory.create(:user)
    job = Factory.create(:job, :creator => user)
    @ability.should_not be_able_to(:destroy, job)
  end
end
