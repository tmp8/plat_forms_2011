require 'test_helper'

class ConferenceTest < ActiveSupport::TestCase
  setup do
    Conference.delete_all
    update_index
  end
  
  def update_index
    Conference.index
    Sunspot.commit
  end
  
  context "search" do
    
    should "find by name" do
      record = Factory(:conference, :name => "is Hamburg beautiful", :description => "some")
      update_index
      
      assert_equal [record], Conference.query(:term => 'Hamburg')
    end
    
    should "find by description" do
      record = Factory(:conference, :description => "Yes, Hamburg is ever beautiful", :name => "some")
      update_index
      
      assert_equal [record], Conference.query(:term => 'Hamburg')
    end
    
    context "categories" do 
      
      should "find exact category" do
        conference = Factory(:conference)
      
        root_cat = Factory(:category)
        conference.conference_categories.create(:category => root_cat)
        update_index
      
        assert_equal [conference], Conference.query(:categories => [root_cat])
      end
      
      should "not find sub_categories" do
        conference = Factory(:conference)
      
        root_cat = Factory(:category)
        some_cat = Factory(:category, :parent => root_cat)
        conference.conference_categories.create(:category => some_cat)
        update_index
      
        assert_equal [conference], Conference.query(:categories => [root_cat], :include_subcategories => true)
      end
    end
    
    context "by date" do
      # MUST
      should "find when date is given" do
        c09 = Factory(:conference, :startdate => Date.new(2009,5,22), :enddate => Date.new(2009,6,1))
        c10 = Factory(:conference, :startdate => Date.new(2010,5,22), :enddate => Date.new(2010,6,1))
        c11 = Factory(:conference, :startdate => Date.new(2011,5,22), :enddate => Date.new(2011,6,1))
        update_index

        [Date.new(2000,1,1), Date.new(2009,6,1)].each do |startdate|
          assert_equal [c09, c10, c11], Conference.query(:startdate => startdate)
        end
        
        [Date.new(2009,6,2), Date.new(2010,6,1)].each do |startdate|
          assert_equal [c10, c11], Conference.query(:startdate => startdate)
        end
        
        [Date.new(2010,6,2), Date.new(2011,6,1)].each do |startdate|
          assert_equal [c11], Conference.query(:startdate => startdate)
        end
        
        [Date.new(2011,6,2)].each do |startdate|
          assert_equal [], Conference.query(:startdate => startdate)
        end

        [Date.new(2011,6,2)].each do |enddate|
          assert_equal [c09, c10, c11], Conference.query(:enddate => enddate)
        end

        [Date.new(2011,5,21)].each do |enddate|
          assert_equal [c09, c10], Conference.query(:enddate => enddate)
        end

        [Date.new(2010,5,21)].each do |enddate|
          assert_equal [c09], Conference.query(:enddate => enddate)
        end

        [Date.new(2000,5,21)].each do |enddate|
          assert_equal [], Conference.query(:enddate => enddate)
        end
      end
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
