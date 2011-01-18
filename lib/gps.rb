module GPS
  def lat_lng_from_string(string)
    (/(\d+(\.\d+)?) ?[NnSs] ?,? ?(\d+(\.\d+)?) ?[EeWw]/ =~ string) && [$1, $3]
  end
  module_function :lat_lng_from_string
  
  def geocode(string)
    geo_loc = Geokit::Geocoders::GoogleGeocoder.geocode(CGI::escape(string))
    {city: geo_loc.city, country_code: geo_loc.country_code}
  end
  module_function :geocode
end