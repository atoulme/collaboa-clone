# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  
  def not_permitted
    respond_to do |format|
      format.html { redirect_to login_path}
      format.xml {basic_authentication}
      format.atom {basic_authentication}
    end
  end
  
  protected
  def load_project
    @project = Project.find(params[:project_id])
  end
  
  def ensure_user_has_permission_to(permission)
    not_permitted and return unless current_user.has_permission_to?(permission, :for => @project)
  end
  
  def basic_authentication
    headers["Status"]           = "Unauthorized"
    headers["WWW-Authenticate"] = %(Basic realm="Collaboa Login")
    render(:text => "Access Denied\n", :status => 401)
  end
end
