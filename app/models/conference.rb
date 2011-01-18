# origin: M

# FIXME!
WebMock.disable_net_connect!(:allow_localhost => true) if defined? WebMock

class Conference < ActiveRecord::Base
  
  belongs_to :series
  
  has_many :conference_participations, :dependent => :destroy
  has_many :participants, :through => :conference_participations, :source => :user
  has_many :conference_categories, :dependent => :destroy
  has_many :categories, :through => :conference_categories

  validates_presence_of :name
  validates_presence_of :startdate
  validates_presence_of :enddate
# FIXME  validates_presence_of :categories
  validates_presence_of :description
  validates_presence_of :location
  
  searchable do 
    text :text
    text :description     
    #    integer :category, :multiple => true, :using => :category_ids
    date :startdate
    # date :enddate
    # string :country_code
    # location :coordinates do
    #   self
    # end
  end

  def text
    "#{name} #{description}"
  end
  
  # def category_ids
  # end

  class << self
    def query(term = nil, startdate = nil, enddate = nil)
      Conference.search do
        keywords(term) if term
        # with(:startdate).greater_than(startdate - 1) if startdate
        # with(:enddate).less_equal(enddate) if enddate
        # with(:coordinates).near(a.lat.to_f, a.lng.to_f, :precision => 10) 
      end.results
    end
  end

  def location=(location)
    write_attribute(:location, location)
    geo_location = GPS.geocode(location)
    write_attribute(:city, geo_location[:city])
    write_attribute(:country_code, geo_location[:country_code])
    location
  end

  def gps=(gps)
    unless gps.blank?
      lat, lng = GPS.lat_lng_from_string(gps)
      write_attribute(:lat, lat)
      write_attribute(:lng, lng)
    else
      write_attribute(:lat, nil)
      write_attribute(:lng, nil)
    end
    write_attribute(:gps, gps)
  end
end
