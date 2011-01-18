# encoding: utf-8

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

module WebmockStubs
  def google_maps
    WebMock.stub_request(:get, /.*maps.google.com.*/).to_return(:status => 200, :body => <<-EOS
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
    )
  end
  module_function :google_maps
end

WebMock.disable_net_connect!(:allow_localhost => true)
WebmockStubs.google_maps

class ActiveSupport::TestCase
  
  include ::FixtureBackground::ActiveSupport::TestCase
  include RR::Adapters::TestUnit

  setup do
    WebmockStubs.google_maps
  end
  # Add more helper methods to be used by all tests here...
  
  protected
  
  def create_activated_user
    user = Factory.build(:user)
    user.skip_confirmation!
    user.save!
    user
  end
  
  def create_admin_user
    user = Factory.build(:admin)
    user.skip_confirmation!
    user.save!
    user
  end
  
  # verbatim, from ActiveController's own unit tests
   def encode_credentials(username, password)
     "Basic #{ActiveSupport::Base64.encode64("#{username}:#{password}")}"
   end
   
   def raw_post(action, params, body)
      @request.env['RAW_POST_DATA'] = body
      response = post(action, params)
      @request.env.delete('RAW_POST_DATA')
      response
    end
end
