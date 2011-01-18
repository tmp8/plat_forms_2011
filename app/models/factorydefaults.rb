class Factorydefaults
  class << self
    def load
      users, categories, conference_series, conferences = load_json_data

      conferences.each do |conference_data|
        lat, lng = GPS.lat_lng_from_string(conference_data['gps'])
        geo_location = GPS.geocode(conference_data['location'])
        
        conference = Conference.create!({
          name: conference_data['name'],
          description: conference_data['description'],
          location: conference_data['location'],
          gps: conference_data['gps'],
          venue: conference_data['venue'],
          accomodation: conference_data['accomodation'],
          howtofind: conference_data['howtofind'],
          startdate: conference_data['startdate'],
          enddate: conference_data['enddate'],
          lat: lat,
          lng: lng,
          city: geo_location[:city],
          country: geo_location[:country_code]
        })
      end
    end
    
    private
      def load_json_data
        JSON.parse(IO.read(File.dirname(__FILE__) + '/../../db/data.txt'))
      end
  end
end