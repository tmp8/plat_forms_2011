# origin: M

class Conference < ActiveRecord::Base
  has_many :conference_participations
  has_many :participants, :through => :conference_participations, :source => :user
end
