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
        go_to project_tickets_path(@project), :if_user_has_permission_to => :view_tickets
        go_to new_project_ticket_path(@project), :if_user_has_permission_to => :add_tickets
        redirect_to login_path and return unless performed?
      end
      format.xml { render :xml => @project}
    end
  end

  # GET /projects/new
  # GET /projects/new.xml
  def new
    ensure_user_has_permission_to :add_projects
    
    @project = Project.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/1/edit
  def edit
    ensure_user_has_permission_to :update_projects
    
    @project = Project.find(params[:id])
  end

  # POST /projects
  # POST /projects.xml
  def create
    ensure_user_has_permission_to :add_projects
    
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save
        flash[:notice] = 'Project was successfully created.'
        format.html { redirect_to(@project) }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    ensure_user_has_permission_to :update_milestones
    
    @project = Project.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        flash[:notice] = 'Project was successfully updated.'
        format.html { redirect_to(@project) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    ensure_user_has_permission_to :remove_milestones
    
    @project = Project.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(projects_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
  def go_to(url, options = {})
    if !performed? && current_user.has_permission_to?(options[:if_user_has_permission_to], :for => @project)
      redirect_to(url) and return
    end
  end
end
