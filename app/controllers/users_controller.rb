#origin: M

class UsersController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :load_user, :only => [:show, :update]
  
  def show
    render :json => @user.to_json
  end
  
  def update
    if current_user == @user && @user.update_attributes(parse_raw_json)
      render :json => @user.to_json
    elsif current_user != @user
      render :json => "Forbidden", :status => 403
    else
      render :json => "Bad Request", :status => 400
    end
  end
  
  def create
    @user = User.new(parse_raw_json)
    @user.skip_confirmation!
    if @user.save
      render :json => @user.to_json
    else
      render :json => "Bad Request", :status => 400
    end
  end
  
  private
    def load_user
      @user = User.find_by_username(params[:id])
      raise ActiveRecord::RecordNotFound unless @user
    end
end
