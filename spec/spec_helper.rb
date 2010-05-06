# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path(File.join(File.dirname(__FILE__),'..','config','environment'))
require 'spec/autorun'
require 'spec/rails'
require 'mail'

# Uncomment the next line to use webrat's matchers
#require 'webrat/integrations/rspec-rails'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

require 'factory_girl'
Dir[File.expand_path(File.join(File.dirname(__FILE__),'factories','**','*_factory.rb'))].each {|f| require f}

require "authlogic/test_case"
include Authlogic::TestCase

def login_as! user
  activate_authlogic
  UserSession.create!(user)
end

def logout!
  UserSession.find.destroy
end

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
end

class MailCreator
  def self.default_mail_headers
    { "body" => "I would like to let you know that the special fabric softener that you emailed to my postbox was quite nice in the smelly department ;) it made all of my underwears smell like lavendar roses. I would pay tens of dollars for this in the real world",
      "from" => "flubs@gebarchnik.com",
      "to" => "donkeytron@wizzled.biz",
      "message_id" => "<abc45566@revetonkatruck.local.tmail>",
      "date" => "Wed, 23 Sep 2009 09:11:23 -0700"
    }
  end
  
  def self.new_mail(hash={})
    headers = default_mail_headers.merge(hash)
    mail = Mail.new do
      text_part do
        body headers.delete("body")
      end
    end
    headers.each {|header, content| mail[header] = content }
    mail
  end
end