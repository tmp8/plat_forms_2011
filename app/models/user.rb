class User < ActiveRecord::Base
  NO_CONTACT = 0
  RCD_SENT = 1
  RCD_RECEIVED = 2
  IN_CONTACT = 3

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :friendships
  has_many :friendship_requests, :class_name => "Friendship", :foreign_key => "friend_id"    
  
  has_many :friends, :through => :friendships

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
end
