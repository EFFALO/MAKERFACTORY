require 'spec_helper'

describe PagesController do
  describe "access control" do
    it "should allow anonymous users to get home" do
      get :home
      response.should be_success
    end
  end
end
