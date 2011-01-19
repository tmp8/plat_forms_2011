class NotificationsController < ApplicationController
  before_filter :authenticate_user!

  def create
    friends = []
    conference = Conference.find(params[:conference_id])
    current_user.transaction do
      params[:user].keys.each do |friend_id|
        friend = User.find(friend_id)
        friends << friend
        current_user.create_conference_invitation_for(friend, conference)
      end
    end
    redirect_to :back, :notice => "Invitations sent to #{friends.map(&:username).join(', ')}!"
  end
end
