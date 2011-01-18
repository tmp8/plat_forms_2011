class SeriesController < ApplicationController
  
  before_filter :authenticate_user!, :only => [:create]
  
  def index
    render :status => 501, :text => "Not Implemented"
  end
  
  def show
    render :status => 501, :text => "Not Implemented"
  end
  
  def create
    render :status => 501, :text => "Not Implemented"
  end 
end
