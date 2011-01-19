class FriendshipRequestsController < ApplicationController
  before_filter :authenticate_user!
  
  def send_many
    current_user.transaction do
      params[:user].keys.each do |new_friend_id|
        current_user.request_friendship(User.find(new_friend_id))
      end
    end
    redirect_to :back, :notice => "Request(s) sent!"
  end
end
