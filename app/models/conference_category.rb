#origin: M

class ConferenceCategory < ActiveRecord::Base
  after_save :touch_conference
  
  belongs_to :conference
  belongs_to :category
  
  private
    def touch_conference
      category.touch
    end
end
