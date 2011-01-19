#origin M
class CategoriesController < ApplicationController

  before_filter :authenticate_user!, :except => [:show]
  before_filter :ensure_admin!, :only => [:create]
  
  def index
    @categories = Category.root.all
    render :json => @categories.to_json, :status => (@categories.blank? ? 204 : 200)
  end
  
  def show
    @category = Category.find(params[:id])
    
    respond_to do |format|
      format.html { render :action => 'show' }
      format.json { render :json => @category.to_json }
    end
  end
  
  def conferences
    @category = Category.find(params[:id])
    @conferences = @category.conferences
    render :json => @conferences.to_json, :status => (@categories.blank? ? 204 : 200)
  end
  
  def create
    @category = Category.new(parse_raw_json)
    if @category.save
      render :json => @category.to_json
    else
      render :json => "", :status => 400
    end
  rescue ActiveRecord::UnknownAttributeError => e
    render :json => "", :status => 400    
  end

end
