require 'test_helper'

class ConferenceTest < ActiveSupport::TestCase
  context "search" do
    
    should "find by name" do
      record = Factory(:conference, :name => "is Hamburg beautiful", :description => "some")
      Conference.index
      assert_equal [record], Conference.query('Hamburg')
    end
    
    should "find by description" do
      record = Factory(:conference, :description => "Yes, Hamburg is ever beatiful", :name => "some")
      Conference.index
      assert_equal [record], Conference.query('Hamburg')
    end

    context "by date" do
      # should "find when startdate is given" do
      #   zero = Factory(:conference, :startdate => Date.new(2009,5,22), :enddate => Date.new(2009,5,22))
      #   one = Factory(:conference, :startdate => Date.new(2010,5,22), :enddate => Date.new(2010,5,22))
      #   two = Factory(:conference, :startdate => Date.new(2011,5,22), :enddate => Date.new(2011,5,22))
      #   Conference.index
      #   assert_equal [one, two], Conference.query(nil, Date.new(2010,5,22))
      # end
    end
  end

end
