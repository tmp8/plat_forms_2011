class ConferencesController < ApplicationController

  before_filter :authenticate_user!
  
  def create
    @conference = current_user.organizing_conferences.create(params[:conference])
    respond_to do |format|
      format.json { @re}
    end
  end
end
