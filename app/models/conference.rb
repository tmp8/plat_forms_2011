# origin: M
class Conference < ActiveRecord::Base
  include GPSResolver
  
  belongs_to :series
  
  has_many :conference_participations, :dependent => :destroy
  has_many :participants, :through => :conference_participations, :source => :user
  has_many :conference_categories, :dependent => :destroy
  has_many :categories, :through => :conference_categories
  
  belongs_to :organizator, :class_name => "User"

  validates_presence_of :name
  validates_presence_of :startdate
  validates_presence_of :enddate
# FIXME  validates_presence_of :categories
  validates_presence_of :description
  validates_presence_of :location

  class << self
    
    def build_from_json(conference_json, user)
      conference_hash = JSON.parse(CGI.unescape(conference_json))
      categories = conference_hash.delete("categories")
      conference = new(conference_hash)
      conference.organizator = user
      if categories 
        categories = categories.map do |category|
          Category.find_by_name(category["name"])
        end
        conference.categories << categories
      end
      conference
    end
    
  end
  
  def update_from_params(params) 
    if params[:format] == "json"
      self.attributes = JSON.parse(params[:conference])
    else
      self.attributes = params[:conference]
    end
    save!
  end
  
  def location=(location)
    write_attribute(:location, location)
    geo_location = GPS.geocode(location)
    write_attribute(:city, geo_location[:city])
    write_attribute(:country_code, geo_location[:country_code])
    location
  end
end
