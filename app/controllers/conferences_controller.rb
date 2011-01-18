class ConferencesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :throw_not_implemented_for_json, :only => [:index, :show, :update, :destroy]

  def create
    @conference = current_user.organizing_conference.new(params[:conference])
    respond_to do |format|
      if @conference.save
        format.html { redirect_to(conferences_path, :notice => 'Conference was successfully created.' }
        format.json { render :json => @conference.to_json }
      else
        format.html { render :action => "new" }
        format.json { render :status => 400, :text => "Cannot save!"  }
      end
    end
  end

  def index
    @conferences = Conference.all
    respond_to do |format|
      format.html { }
    end
  end

  def show
    @conference = Conference.find(params[:id])
    respond_to do |format|
      format.html { }
    end
  end
  
  def update
    @conference = current_user.organizing_conferences.find(params[:id]) 
    respond_to do |format|
      format.html { }
    end
  end
  
  def new
    @conference = Conference.new
  end

  def edit
    @conference = current_user.organizing_conferences.find(params[:id])
  end

  def create
    @conference = Conference.new(params[:conference])

    if @conference.save
      redirect_to(conferences_path, :notice => 'Conference was successfully created.')
    else
      render :action => "new"
    end
  end
  
  private 
    def throw_not_implemented_for_json
      if params[:format] == 'json'
        render :status => 501, :text => "Not Implemented" and return false
      end
    end
end
