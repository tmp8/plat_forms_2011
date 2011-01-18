class ConferencesController < ApplicationController

  before_filter :authenticate_user!
  
  def create
    @conference = current_user.organizing_conferences.create(params[:conference])
    respond_to do |format|
      format.json { render :json => @conference.to_json }
    end
  end
  
  def index
    render :status => 501, :text => "Not Implemented"
  end
  
  def show
    render :status => 501, :text => "Not Implemented"
  end
  
  def update
    render :status => 501, :text => "Not Implemented"
  end
  
  def destroy
    render :status => 501, :text => "Not Implemented"
  end
end
