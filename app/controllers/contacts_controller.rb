class ContactsController < ApplicationController
  
  before_filter :load_user
  
  def index
    render :status => 501, :text => "Not Implemented"
  end
  
  def show
    render :status => 501, :text => "Not Implemented"
  end
  
  private
    
    def load_user
      #TODO implement
      @user = User.find_by_username(params[:id])
    end
end
