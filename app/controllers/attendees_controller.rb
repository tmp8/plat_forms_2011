#origin M

class AttendeesController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :load_conference
  
  def index
    @attendees = @conference.participants
    if @attendees.blank? 
      render :json => "", :status => 204
    else
      render :json => @attendees.to_json
    end
  end
  
  def create
    username = parse_raw_json["username"]
    if user = User.find_by_username(username)
      if user != current_user
        render :json => "Forbidden", :status => 403
      else
        user.attend!(@conference)
        render :json => "", :status => 204
      end
    else
      raise ActiveRecord::RecordNotFound
    end
  end
  
  def destroy
    if user = User.find_by_username(params[:id])
      if user != current_user
        render :json => "Forbidden", :status => 403
      else
        user.wont_attend!(@conference)
        render :json => "", :status => 204
      end
    else
      raise ActiveRecord::RecordNotFound
    end    
  end
  
  private
    def load_conference
      @conference = current_user.organizing_conferences.find(params[:conference_id])
    end
end
