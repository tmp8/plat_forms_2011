if ENV['COVERAGE']
  require 'simplecov'
  require 'merged_formatter'
  SimpleCov.formatter = SimpleCov::Formatter::MergedFormatter
  SimpleCov.start 'rails'
end

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'webmock/test_unit'
require 'factories'

class ActiveSupport::TestCase
  
  include ::FixtureBackground::ActiveSupport::TestCase
  include RR::Adapters::TestUnit

  # Add more helper methods to be used by all tests here...
  
  protected
  
  def activated_user
    user = Factory.build(:user)
    user.skip_confirmation!
    user.save
    user
  end
  
  # verbatim, from ActiveController's own unit tests
   def encode_credentials(username, password)
     "Basic #{ActiveSupport::Base64.encode64("#{username}:#{password}")}"
   end
end
