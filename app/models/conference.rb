# origin: M

class Conference < ActiveRecord::Base
  has_many :conference_participations, :dependent => :destroy
  has_many :participants, :through => :conference_participations, :source => :user
  has_many :conference_categories, :dependent => :destroy
  has_many :categories, :through => :conference_categories
  
  def location=(location)
    write_attribute(:location, location)
    geo_location = GPS.geocode(location)
    write_attribute(:city, geo_location[:city])
    write_attribute(:country_code, geo_location[:country_code])
    location
  end
  
  def gps=(gps)
    write_attribute(:gps, gps)
    lat, lng = GPS.lat_lng_from_string(gps)
    write_attribute(:lat, lat)
    write_attribute(:lng, lng)
    gps
  end
end
