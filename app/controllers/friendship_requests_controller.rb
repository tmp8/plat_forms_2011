class FriendshipRequestsController < ApplicationController
  before_filter :authenticate_user!
  
  def send_many
    friends = []
    current_user.transaction do
      params[:user].keys.each do |new_friend_id|
        friend = User.find(new_friend_id)
        friends << friend
        current_user.request_friendship(User.find(new_friend_id))
      end
    end
    redirect_to :back, :notice => "Friendship request sent to #{friends.map(&:username).join(', ')}!"
  end
end
