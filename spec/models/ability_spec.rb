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
end
