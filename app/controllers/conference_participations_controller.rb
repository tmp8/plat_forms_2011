# origin: M

class ConferenceParticipationsController < ApplicationController
  before_filter :authenticate_user!, :only => [:create, :destroy]
  before_filter :load_conference
  
  def create
    current_user.attend!(@conference)
    redirect_to :back, :notice => 'Successfully registered!'
  end
  
  def destroy
    current_user.wont_attend!(@conference)
    redirect_to :back, :notice => 'Successfully un-registered!'
  end

  private 
    def load_conference
      @conference = Conference.find(params[:conference_id])
    end
end
