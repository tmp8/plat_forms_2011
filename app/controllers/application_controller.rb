# origin: M

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  private
    def ensure_admin!
      if current_user.username != 'admin'
        render :status => 403, :nothing => true
        return false
      end
      return true
    end
end
