require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Message do
  it "should clean the email address on create" do
    Factory.create(:message, :from => "--- - donkeys@bizzler.com  ")
    Message.last.from.should == "donkeys@bizzler.com"
  end
end
