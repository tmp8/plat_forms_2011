# origin: M


class Date
  def to_i
    to_s(:db).gsub("-", '').to_i
  end
end

# FIXME!
WebMock.disable_net_connect!(:allow_localhost => true) if defined? WebMock

class Conference < ActiveRecord::Base
  
  belongs_to :series
  
  belongs_to :creator, :foreign_key => :organizator_id, :class_name => 'User'
  
  has_many :conference_participations, :dependent => :destroy
  has_many :participants, :through => :conference_participations, :source => :user
  has_many :conference_categories, :dependent => :destroy
  has_many :categories, :through => :conference_categories
  
  belongs_to :organizator, :class_name => "User"

  validates_presence_of :name
# FIXME startdate < enddate
  validates_presence_of :startdate
  validates_presence_of :enddate
# FIXME  validates_presence_of :categories
  validates_presence_of :description
  validates_presence_of :location
  validates_presence_of :creator
  
  default_scope :order => 'startdate ASC'
  
  scope :running, :conditions => ['startdate <= CURDATE() AND enddate >= CURDATE()']
  scope :tomorrow, :conditions => ['startdate = CURDATE() + 1']
  
  searchable do 
    text :name
    text :description     
    integer :category, :multiple => true, :using => :category_ids

    integer :open_on, :multiple => true, :using => :open_on_date_numbers
    
    # string :country_code
    
    location :coordinates do
      self
    end
  end
  
  def open_on_date_numbers
    (startdate..enddate).to_a.map(&:to_i)
  end
  
  def category_ids
    categories.map(&:id)
  end

  class << self
    def query(opts)
      term = opts.delete(:term)
      startdate = opts.delete(:startdate)
      enddate = opts.delete(:enddate)
      
      if categories = opts.delete(:categories)
        if opts.delete(:include_subcategories)
          categories = categories.map(&:self_with_ancestors).flatten
        end
      end
      
      solr = Conference.search do
        keywords(term) if term
        with(:category).any_of(categories.map(&:id)) if categories
        with(:open_on).greater_than(startdate.to_i) if startdate
        with(:open_on).less_than(enddate.to_i) if enddate

        # with(:coordinates).near(BigDecimal.new('40.7'), BigDecimal.new('-73.5'))
        # with(:enddate).less_equal(enddate) if enddate
        # with(:coordinates).near(a.lat.to_f, a.lng.to_f, :precision => 10) 
      end
      solr.results
    end
  end

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
