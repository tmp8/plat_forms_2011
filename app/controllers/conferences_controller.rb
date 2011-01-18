# origin: M

class ConferencesController < ApplicationController
  before_filter :authenticate_user!
  
  def show
    @conference = Conference.find(params[:id])
  end
  
  def index
    @conferences = Conference.all
  end
  
  def new
    @conference = Conference.new
  end

  def edit
    @conference = Conference.find(params[:id])
  end

  def update
    @conference = Conference.find(params[:id])
    
    if @conference.update_attributes(params[:conference])
      redirect_to(conferences_path, :notice => 'Conference was successfully updated.')
    else
      render :action => "edit"
    end
  end

  def create
    @conference = Conference.new(params[:conference])

    if @conference.save
      redirect_to(conferences_path, :notice => 'Conference was successfully created.')
    else
      render :action => "new"
    end
  end
end
