# origin: M

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  
    
  protected
  
    def render_404(exception)
      respond_to do |format|
        format.json { render :json => "Record Not Found".to_json, :status => 404}
        format.html { render :text => "404", :status => 404}
      end
    end
    
    def ensure_admin!
      unless current_user.admin?
        render :status => 403, :nothing => true
        return false
      end
      return true
    end
    
    def parse_raw_json
      JSON.parse(CGI.unescape(request.raw_post))
    end
end
