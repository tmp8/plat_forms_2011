#origin M

class CategoriesController < ApplicationController

  def index
    render :status => 501, :text => "Not Implemented"
  end
  
  def show
    @category = Category.find(params[:id])
    
    respond_to do |format|
      format.html { render :action => 'show' }
      format.json { render :status => 501, :text => "Not Implemented" }
    end
  end
  
  def create
    render :status => 501, :text => "Not Implemented"
  end

end
