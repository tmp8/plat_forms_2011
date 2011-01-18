class ConferencesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :throw_not_implemented_for_json, :only => [:index, :destroy]
  
  def create
    respond_to do |format|
      
      format.json do
        begin
          @conference = current_user.organizing_conferences.build_from_json(request.raw_post, current_user)
          if @conference.save
            render :json => @conference.to_json 
          else
            render :status => 400, :json => "Cannot save!"
          end
        rescue ActiveRecord::UnknownAttributeError
          render :status => 400, :json => "Cannot save!"
        end
      end
      
      format.html do
        @conference = current_user.organizing_conferences.build(params[:conference])
        if @conference.save
          redirect_to(conferences_path, :notice => 'Conference was successfully created.')
        else
          render :action => "new" 
        end
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
      format.json { render :json => @conference.to_json }
    end
  end
  
  def update
    @conference = current_user.organizing_conferences.find(params[:id]) 
    @conference.attributes = params[:conference] || JSON.parse(CGI.unescape(request.raw_post))
    if @conference.save
      respond_to do |format|
        format.html { }
        format.json { render :json => @conference.to_json }
      end
    end
  end
  
  def new
    @conference = Conference.new
  end

  def edit
    @conference = current_user.organizing_conferences.find(params[:id])
  end
  
  protected 
    def throw_not_implemented_for_json
      if params[:format] == 'json'
        render :status => 501, :text => "Not Implemented" and return false
      end
    end
end
