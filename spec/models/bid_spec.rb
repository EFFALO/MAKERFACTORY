require 'spec_helper'

describe Bid do
  before(:each) do
  end

  it "should validate that the quantity offered is less than or equal to the owning job's need" do
    job = Factory.create(:job, :quantity_needed => 5)
    good_bid = Factory.build(:bid, :job => job, :quantity => 4)
    max_bid = Factory.build(:bid, :job => job, :quantity => 5)
    bad_bid = Factory.build(:bid, :job => job, :quantity => 6)
    
    good_bid.save.should == true
    max_bid.save.should == true
    bad_bid.save.should == false
  end
end
