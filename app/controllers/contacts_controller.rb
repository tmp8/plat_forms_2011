# origin: M
class ContactsController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :load_user
  
  def index
    @contacts = @user.full_friendships(current_user)
    render :json => @contacts.to_json, :status => (@contacts.blank? ? 204 : 200)
  end
  
  def create
    render(:json => "", :status => 400) and return unless valid_json?
    current_user.process_friendship_request(@user, parse_raw_json)
    render :json => "", :status => 204
  end
  
  private
    
    def load_user
      @user = User.find_by_username(params[:user_id])
      raise ActiveRecord::RecordNotFound unless @user
    end
    
    def valid_json?
      json = parse_raw_json
      json.has_key?("positive") && (json["positive"] == true || json["positive"] == false)
    end
end
