require 'spec_helper'

describe Bid do
  before(:each) do
    @valid_attributes = {

    }
  end

  it "should create a new instance given valid attributes" do
    Bid.create!(@valid_attributes)
  end
end
