class MainController < ApplicationController
  before_filter CASClient::Frameworks::Rails::Filter, :only => ['login']
  
  def index
   @projects = Project.show_for_user(current_user) 
  end

  def edit
    redirect_to :controller => "main", :action => "index", :project => current_project if !current_project or !current_user or !current_user.rights_for(current_project).project_admin
    return unless request.post?
    current_project.attributes = params[:project_info]
    current_project.save!
    flash[:notice] = "The project info was successfully modified"
    redirect_to :controller => "main", :action => "index", :project => current_project
  end

  def projects
    @projects = Project.show_for_user(current_user)
    if @projects.length == 1
      redirect_to project_url(:project => @projects[0].short_name)
    end
		
    #if user is Public and has no projects, then redirect to login page
    #for logged in user, let the view show "No projects"		
    redirect_to	:controller=> "main" if !current_user and @projects.empty?
  end

  def logout
    reset_session
    redirect_to(CASClient::Frameworks::Rails::Filter.client.logout_url(request.referer)) and return
  end


  def login
    redirect_to :action => 'index'
  end 
  protected
  
end
