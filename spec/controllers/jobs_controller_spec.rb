require 'spec_helper'

describe JobsController do
  before(:each) do
    @user = Factory.create(:user)
    @job = Factory.create(:job, :creator => @user)
    login_as! @user
  end
  
  describe "access controls" do
    before(:each) do
      logout!
    end
    
    it "anonymous user can get index" do
      get :index
      response.should be_success
    end
    
    it "anonymous users can get show" do
      get :show, :id => @job.id
      response.should be_success
    end
  end

  describe "#index" do
    it "should be successful" do
      get :index
      assigns(:jobs).should == [@job]
      response.should be_success
    end
    
    it "should only get the 10 most recent jobs" do
      now = Time.now
      old_jobs = 10.times.map { Factory.create(:job) }
      new_jobs = 10.times.map { Factory.create(:job, :created_at => now + 1.week) }
      get :index
      assigns[:jobs].to_set.should == new_jobs.to_set
    end

    it "should not show expired jobs" do
      @job.update_attribute(:created_at, Job::EXPIRE_IN.ago - 5)
      jobs = 10.times.map { Factory.create(:job) }
      get :index
      assigns[:jobs].to_set.should == jobs.to_set
    end
    
    it "should allow logged in users" do
      user = Factory.create :user
      login_as! user
      get :index
      response.should be_success
    end
  end

  describe "#show" do
    it "should be successful" do
      get :show, :id => @job.id
      assigns[:job].should == @job
      response.should be_success
    end
    
    it "should have a new bid available" do
      get :show, :id => @job.id
      assigns[:bid].should be_a(Bid)
    end
  end

  describe "#new" do
    it "should make a new jorb" do
      get :new
      assigns[:job].should be_new_record
      response.should be_success
    end
  end

  describe "#create" do
    it "should make a new job with a creator" do
      post :create, :job => Factory.attributes_for(:job)
      job = assigns[:job]
      job.should be_valid
      job.creator.should == @user
      response.should redirect_to job_path(job)
    end
  end

  describe "#edit" do
    it "should be successful" do
      get :edit, :id => @job.id
      assigns[:job].should == @job
      response.should be_success
    end
    
    it "should not let you edit others' jobs" do
      another_user = Factory.create :user
      another_job = Factory.create(:job, :creator => another_user)
      get :edit, :id => another_job.id
      response.should_not be_success
    end
    
    it "should not let you edit your job if bids have been made" do
      bid = Factory.create(:bid, :job => @job)
      get :edit, :id => @job.id
      response.should_not be_success
    end

    it "should not let you edit your job it has expired" do
      bid = Factory.create(:bid, :job => @job, :created_at => 3.weeks.ago)
      get :edit, :id => @job.id
      response.should_not be_success
    end
  end

  describe "#update" do
    it "should update yo jobz" do
      new_title = @job.title + " despite my son's shortcomings"
      job = {:title => new_title}
      put :update, :id => @job.id , :job => job
      assigns[:job].title.should == new_title
      response.should redirect_to job_path(assigns[:job])
    end
    
    it "should not let you update others' jobs" do
      another_user = Factory.create :user
      another_job = Factory.create(:job, :creator => another_user)
      old_title = another_job.title
      put :update, :id => another_job.id, :job => {:title => another_job.title + "some other stuff in quotes"}
      assigns(:job).reload.title.should == old_title
      response.should_not be_success
    end
    
    it "should not let you update your job if bids have been made" do
      bid = Factory.create(:bid, :job => @job)
      old_title = @job.title      
      put :update, :id => @job.id, :job => {:title => @job.title + "some other stuff in quotes"}
      assigns(:job).reload.title.should == old_title
      response.should_not be_success
    end
  end

  describe "delete_image" do
    it "should remove the named image from a job" do
      @job.image1 = File.new(File.join(RAILS_ROOT, "/spec/fixtures/paperclip", "domegramming.jpg"), 'rb') 
      @job.save!
      xhr :put, :delete_image, :id => @job.id, :field_name => 'image1'
      Job.find(@job.id).image1.file?.should == false
    end
  end

end
