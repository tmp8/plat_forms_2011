class MaintenanceController < ApplicationController
  
  before_filter :authenticate_user!
  before_filter :ensure_admin!
  
  def reset
    Factorydefaults.new.reset
    render :status => 204, :nothing => true
  end
  
  def factorydefaults
    Factorydefaults.new.load
    render :status => 204, :nothing => true
  end
  
  private
    def ensure_admin!
      if current_user.username != 'admin'
        render :status => 403, :nothing => true
        return false
      end
      return true
    end
end
