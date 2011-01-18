# origin: GM

class User < ActiveRecord::Base


  NO_CONTACT = 0
  RCD_SENT = 1
  RCD_RECEIVED = 2
  IN_CONTACT = 3

  attr_accessor :login
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :full_name, :country, 
                  :city, :username, :gps, :login
                  
  validates_presence_of :username
  validates_presence_of :country

  has_many :friendships
  has_many :friends, :through => :friendships

  has_many :friendship_requests, :class_name => "Friendship", :foreign_key => "friend_id"    
  
  has_many :conference_participations
  has_many :conferences, :through => :conference_participations
  
  has_many :series_contacts, :foreign_key => :contact_id
  has_many :series, :through => :series_contacts
  
  has_many :organizing_conferences, :class_name => "Conference"

  def request_friendship(friend)
    self.friendships.create(:friend => friend)
  end
  
  def friend_state(other_user)
    if friendships.confirmed.map(&:friend).include? other_user
      IN_CONTACT 
    elsif  friendships.outstanding.map(&:friend).include? other_user 
      RCD_SENT
    elsif other_user.friendships.outstanding.map(&:friend).include? self
      RCD_RECEIVED 
    else
      NO_CONTACT
    end
  end
  
  def attend!(conference)
    conference_participations.create!(:conference => conference)
  rescue ActiveRecord::RecordNotUnique => e
    conference_participations.find_by_conference_id(conference.id)
  end
  
  def wont_attend!(conference)
    attending = conference_participations.detect { |cp| cp.conference == conference }
    attending.destroy if attending
  end
  
  def email=(email)
    write_attribute(:email, email.strip) unless email.nil?
  end
  
  def country=(country)
    unless country.blank?
      write_attribute(:country_code, GPS.geocode(country)[:country_code])
    else
      write_attribute(:country_code, nil)
    end
    write_attribute(:country, country)
  end
  
  def participation_for(conference)
    conference_participations.detect { |cp| cp.conference == conference }
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
  
  protected
    def self.find_for_database_authentication(conditions)
      login = conditions.delete(:login)
      where(conditions).where(["username = :value OR email = :value", { :value => login }]).first
    end
end
