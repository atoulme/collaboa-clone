class ProjectsController < ApplicationController
  # GET /projects
  # GET /projects.xml
  def index
    @projects = current_user.projects.find(:all)
    respond_to do |format|
      format.html do
        redirect_to project_path(@projects.first) and return if @projects.size == 1
        redirect_to login_path and return if @projects.empty?
      end
      format.xml  { render :xml => @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    @project = current_user.projects.find(params[:id])
    
    respond_to do |format|
      format.html do
        # Check the current user has appropriate permissions before redirecting.
        go_to project_changesets_path(@project), :if_user_has_permission_to => :view_changesets
        go_to project_repository_path(@project), :if_user_has_permission_to => :view_repository
        go_to project_milestones_path(@project), :if_user_has_permission_to => :view_milestones
        go_to project_tickets_path(@project),    :if_user_has_permission_to => :view_tickets
        go_to new_project_ticket_path(@project), :if_user_has_permission_to => :add_tickets
        redirect_to login_path and return unless performed?
      end
      format.xml { render :xml => @project}
    end
  end
  
  protected
  def go_to(url, options = {})
    if !performed? && current_user.has_permission_to?(options[:if_user_has_permission_to], :for => @project)
      redirect_to(url) and return
    end
  end
end
