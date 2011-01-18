require 'test_helper'

class ConferenceTest < ActiveSupport::TestCase
  setup do 
    Conference.delete_all
  end
  
  context "search" do
    
    should "find by name" do
      record = Factory(:conference, :name => "is Hamburg beautiful", :description => "some")
      Conference.index
      assert_equal [record], Conference.query('Hamburg')
    end
    
    should "find by description" do
      record = Factory(:conference, :description => "Yes, Hamburg is ever beautiful", :name => "some")
      Conference.index
      assert_equal [record], Conference.query('Hamburg')
    end
    
    
    context "categories" do 
      
      should "find exact category" do
        conference = Factory(:conference)
      
        root_cat = Factory(:category)
        conference.conference_categories.create(:category => root_cat)
        Conference.index
      
        assert_equal [conference], Conference.query(nil, nil, nil, [root_cat])
      end
      
      should "not find sub_categories" do
        conference = Factory(:conference)
      
        root_cat = Factory(:category)
        some_cat = Factory(:category, :parent => root_cat)
        conference.conference_categories.create(:category => some_cat)
        Conference.index
      
        assert_equal [conference], Conference.query(nil, nil, nil, root_cat.self_with_ancestors)
      end
    end

    context "by date" do
      # MUST
      # should "find when startdate is given" do
      #   zero = Factory(:conference, :startdate => Date.new(2009,5,22), :enddate => Date.new(2009,5,23))
      #   one = Factory(:conference, :startdate => Date.new(2010,5,22), :enddate => Date.new(2010,5,23))
      #   two = Factory(:conference, :startdate => Date.new(2011,5,22), :enddate => Date.new(2011,5,23))
      #   Conference.index
      #   assert_equal [one, two], Conference.query(nil, Date.new(2010,5,21))
      # end
    end
    
    context "by distance" do
      # may
      # should "find conference by withing distance" do
      #   in_berlin = Factory(:conference, :city => "Berlin", :gps => "52.31N,13.24E")
      #   in_long_beach = Factory(:conference, :city => "Berlin", :gps => "533.76N,118.18W")
      #   Conference.index
      #   
      #   Conference.query(nil, Date.new(2010,5,22))
      # end
    end
  end

end
