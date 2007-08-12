# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  
  def not_permitted
    respond_to do |format|
      format.html { redirect_to login_path}
      format.xml {render(:text => "Access Denied\n", :status => 401)}
      format.atom {render(:text => "Access Denied\n", :status => 401)}
    end
  end
  
  protected
  def load_project
    @project = Project.find(params[:project_id])
  end
  
  def ensure_user_has_permission_to(permission)
    not_permitted and return unless current_user.has_permission_to?(permission, :for => @project)
  end
end
