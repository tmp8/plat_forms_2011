#origin: M

class ConferenceCategory < ActiveRecord::Base
  belongs_to :conference
  belongs_to :category
end
