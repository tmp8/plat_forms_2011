# origin: M
class Conference < ActiveRecord::Base
  include GPSResolver
  
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
  
  default_scope :order => 'startdate ASC'
  
  named_scope :running, :conditions => ['startdate >= CURDATE() AND enddate <= CURDATE()']
  named_scope :tomorrow, :conditions => ['startdate = CURDATE() + 1']

  def location=(location)
    write_attribute(:location, location)
    geo_location = GPS.geocode(location)
    write_attribute(:city, geo_location[:city])
    write_attribute(:country_code, geo_location[:country_code])
    location
  end
end
