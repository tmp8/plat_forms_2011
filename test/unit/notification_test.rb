require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  context "validations" do
    
    setup do
      @notification = Factory(:notification)
    end
    
    should validate_presence_of(:user)
    should validate_presence_of(:receiver)
    should validate_presence_of(:subject)
  end
end
