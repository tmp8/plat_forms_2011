# origin: M


class Friendship < ActiveRecord::Base
  OUTSTANDING = 0
  CONFIRMED = 1
  REJECTED = -1

  belongs_to :user
  belongs_to :friend, :class_name => "User", :foreign_key => "friend_id"
  
  scope :outstanding, where("status = #{OUTSTANDING}")
  scope :confirmed, where("status = #{CONFIRMED}")

  def outstanding?
    status == OUTSTANDING
  end
  
  def reject!
    return unless outstanding?
    destroy
  end
  
  def confirm!
    return unless outstanding?

    transaction do
      friendship_starts_at = Time.now
      self.status = CONFIRMED
      self.status_changed_at = friendship_starts_at
      Friendship.create!(:user => friend, :friend => user, :status => CONFIRMED, :status_changed_at => friendship_starts_at)
      save!
    end
  end
end
