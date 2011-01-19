#origin M

class ConferencesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :throw_not_implemented_for_json, :only => [:index, :destroy]
  
  def create
    respond_to do |format|
      
      format.json do
        begin
          @conference = current_user.organizing_conferences.build_from_json(parse_raw_json, current_user)
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
          redirect_to(conference_path(@conference), :notice => 'Conference was successfully created.')
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
  
  def search
    @conference = Conference.new(params[:conference])
    @empty_form = params[:commit].blank?
    
    unless @empty_form
      @conferences = Conference.query(
        :term => @conference.name, 
        :startdate => @conference.startdate,
        :enddate => @conference.enddate,
        :categories => @conference.categories,
        :include_subcategories => params[:include_subcategories] == "1"
      )
    else
      @conferences = []
    end
  end
  
  def update
    @conference = current_user.organizing_conferences.find(params[:id]) 
    @conference.attributes = params[:conference] || parse_raw_json
    respond_to do |format|
      format.json do
        if @conference.save
          render :json => @conference.to_json
        end
      end
    
      format.html do
        if @conference.save
          redirect_to(conference_path(@conference), :notice => 'Conference was successfully updated.')
        end
      end
    end
  end
  
  def new
    @conference = Conference.new
  end

  def edit
    @conference = current_user.organizing_conferences.find(params[:id])
  end
  
  def ical
    conference = Conference.find(params[:conference_id])
    
    cal = Icalendar::Calendar.new
    cal.event do
      dtstart     conference.startdate
      dtend       conference.enddate
      summary     conference.name
      description conference.description
    end
    
    headers['Content-Type'] = "text/calendar; charset=UTF-8"
    render :text => cal.to_ical, :layout => false
  end
  
  protected 
    def throw_not_implemented_for_json
      if params[:format] == 'json'
        render :status => 501, :text => "Not Implemented" and return false
      end
    end
  
end
