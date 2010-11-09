require 'spec_helper'
require 'timecop'

describe Job do

  it "should only allow reasonable delivery dates" do
    old_job = Factory.build(:job, :deliver_by => Date.yesterday)
    today_job = Factory.build(:job, :deliver_by => Date.today)
    future_job = Factory.build(:job, :deliver_by => Date.tomorrow)    
    
    old_job.save.should == false
    today_job.save.should == false
    future_job.save.should == true
  end

  describe "scopes" do
    before(:each) do
      @grace_time = 5
    end

    describe "#active" do
      it "should only find jobs created in the last 3 weeks" do
        Timecop.freeze(Time.now) do
          job         = Factory.create(:job)
          expired_job = Factory.create(:job, :created_at => 3.weeks.ago - @grace_time)
          Job.active.should == [job]
        end
      end
    end

    describe "#inactive" do
      it "should only find jobs created more than 3 weeks ago" do
        Timecop.freeze(Time.now) do
          job         = Factory.create(:job)
          expired_job = Factory.create(:job, :created_at => 3.weeks.ago - @grace_time)
          Job.inactive.should == [expired_job]
        end
      end
    end

  end

  describe "#expired?" do

    it "should expire in 3 weeks" do
      job = Factory.create(:job)
      job.expired?.should be_false

      job.update_attribute(:created_at, 3.weeks.ago)
      job.reload
      job.expired?.should be_true
    end

  end

end
