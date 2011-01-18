# encoding: utf-8
# origin: M
require 'test_helper'

class FactorydefaultsTest < ActiveSupport::TestCase

  setup do
    geocode_xml = <<-EOS
    <?xml version="1.0" encoding="UTF-8" ?> 
    <kml xmlns="http://earth.google.com/kml/2.0"><Response> 
      <name>bcc Berliner Congress Center, Berlin, Germany</name> 
      <Status> 
        <code>200</code> 
        <request>geocode</request> 
      </Status> 
      <Placemark id="p1"> 
        <address>bcc Berliner Congress Center GmbH, Alexanderstraße 11, 10178 Berlin, Bundesrepublik Deutschland</address> 
        <AddressDetails Accuracy="9" xmlns="urn:oasis:names:tc:ciq:xsdschema:xAL:2.0"><Country><CountryNameCode>DE</CountryNameCode><CountryName>Bundesrepublik Deutschland</CountryName><Locality><LocalityName>Berlin</LocalityName><Thoroughfare><ThoroughfareName>bcc Berliner Congress Center GmbH, Alexanderstraße 11</ThoroughfareName></Thoroughfare><PostalCode><PostalCodeNumber>10178</PostalCodeNumber></PostalCode><AddressLine>bcc Berliner Congress Center GmbH</AddressLine></Locality></Country></AddressDetails> 
        <ExtendedData> 
          <LatLonBox north="52.5272199" south="52.5136411" east="13.4323414" west="13.4003266" /> 
        </ExtendedData> 
        <Point><coordinates>13.4163340,52.5204310,0</coordinates></Point> 
      </Placemark> 
    </Response></kml>
    EOS
    stub_request(:get, /.*maps.google.com.*/).to_return(:status => 200, :body => geocode_xml)
  end

  test "conference import" do
    Factorydefaults.load
    conference = Conference.first
    
    assert_equal "26C3 - Here Be Dragons", conference.name
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
    assert_equal "DE", conference.country
  end
end
