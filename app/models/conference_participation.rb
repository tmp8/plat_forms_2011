# origin: M

class ConferenceParticipation < ActiveRecord::Base
  belongs_to :user
  belongs_to :conference
end
