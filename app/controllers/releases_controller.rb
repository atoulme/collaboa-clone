class ReleasesController < ProjectAreaController

  def index
    
  end

  def create
    return unless request.post?
    release = Release.new(params[:release])
    release.project = current_project
    release.save!
    flash[:notice] = "The release was successfully created"
    redirect_to :controller => "releases", :action => "index", :project => current_project
  end


  def edit
    @release = Release.find_by_id(params[:id])
    return unless request.post?
    @release.attributes = params[:release]
    @release.save!
    flash[:notice] = "The release was successfully modified"
    redirect_to :controller => "releases", :action => "index", :project => current_project
  end

  def delete
    release = Release.find_by_id(params[:id])
    release.destroy
    flash[:notice] = "The release was successfully deleted"
    redirect_to :controller => "releases", :action => "index", :project => current_project
  end

  def authorized?
    return false if !current_project
    return (current_user and current_user.rights_for(current_project) and current_user.rights_for(current_project).project_admin) if %w[create edit delete].include? params[:action]
    true
  end
end
