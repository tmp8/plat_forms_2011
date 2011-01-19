module GPS
  
  def lat_lng_from_string(string)
    (/(\d+(\.\d+)?) ?[NnSs] ?,? ?(\d+(\.\d+)?) ?[EeWw]/ =~ string) && [$1, $3]
  end
  module_function :lat_lng_from_string
  
  def geocode(string)
    {city: nil, country_code: nil}.tap do |result|
      unless string.blank?
        begin
          geo_loc = Geokit::Geocoders::GoogleGeocoder.geocode(CGI::escape(string))
          result[:city] = geo_loc.city
          result[:country_code] = geo_loc.country_code
        rescue Geokit::TooManyQueriesError
          Rails.logger.warn { "Geokit is over rate limit!" }
        end
      end
    end
  end
  module_function :geocode
end