require 'spec_helper'

describe Job do
  it "should only allow reasonable delivery dates" do
    old_job = Factory.build(:job, :deliver_by => Date.yesterday)
    today_job = Factory.build(:job, :deliver_by => Date.today)
    future_job = Factory.build(:job, :deliver_by => Date.tomorrow)    
    
    old_job.save.should == false
    today_job.save.should == false
    future_job.save.should == true
  end

end
