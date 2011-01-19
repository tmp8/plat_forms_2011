# origin: M
class Notification < ActiveRecord::Base
  belongs_to :user
  belongs_to :receiver, :class_name => "User"
  belongs_to :subject, :polymorphic => true
  
  validates_presence_of :user
  validates_presence_of :receiver
  validates_presence_of :subject
end
