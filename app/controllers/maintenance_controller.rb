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
end
