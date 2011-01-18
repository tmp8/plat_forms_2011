# encoding: utf-8
# origin: M
require 'test_helper'

class FactorydefaultsTest < ActiveSupport::TestCase

  setup do
    factorydefaults = Factorydefaults.new
    factorydefaults.load
    
    @it_security = Category.find_by_name('IT Security')
    @design = Category.find_by_name('Design')
    @technology = Category.find_by_name('Technology')
    @mobile_platforms = Category.find_by_name('Mobile Platforms')
  end

  test "conference import" do
    conference = Conference.find_by_name("26C3 - Here Be Dragons")
    
    assert_equal "The 26th Chaos Communication Congress (26C3) is the annual four-day conference organized by the Chaos Computer Club (CCC). It takes place from December 27th to December 30th 2009 at the bcc Berliner Congress Center in Berlin, Germany.", conference.description
    assert_equal "bcc Berliner Congress Center, Berlin, Germany", conference.location
    assert_equal "52.31N,13.24E", conference.gps
    assert_equal "Alexanderstr. 11, 10178 Berlin, Germany", conference.venue
    assert_equal "", conference.accomodation
    assert_equal "", conference.howtofind
    
    assert_equal Date.new(2009, 12, 27), conference.startdate
    assert_equal Date.new(2009, 12, 30), conference.enddate
    
    assert_equal BigDecimal.new("52.31"), conference.lat
    assert_equal BigDecimal.new("13.24"), conference.lng
    
    assert_equal "Berlin", conference.city
    assert_equal "DE", conference.country_code
    
    assert_equal [@technology, @it_security, @mobile_platforms, @design], conference.categories
  end
  
  test "categories import" do
    assert_nil @design.parent
    assert @design.sub_categories.empty?
    
    assert_equal @technology, @mobile_platforms.parent
    assert @mobile_platforms.sub_categories.empty?
    
    assert_nil @technology.parent
    assert_equal [@it_security, @mobile_platforms], @technology.sub_categories
  end
  
  test "users import" do
    user = User.find_by_username('sballmer')
    
    assert_not_nil user.encrypted_password
    assert_equal 'Steve Ballmer', user.full_name
    assert_equal 'steve.ballmer@example.com', user.email
    assert_equal 'Redmond', user.city
    assert_equal 'United States', user.country
    assert_equal '47.40N,122.7W', user.gps

    assert_equal BigDecimal.new("47.4"), user.lat
    assert_equal BigDecimal.new("122.7"), user.lng
    
    assert_equal "DE", user.country_code # is DE because of Webmock stub
    
    assert user.series.empty?
  end
  
  test "series import" do
    series = Series.find_by_name('ICSE')
    user = User.find_by_username('MichelleLehmann')
    
    assert_equal [user], series.contacts
    assert_equal [series], user.series
  end
end
