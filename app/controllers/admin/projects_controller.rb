class Admin::ProjectsController < AdminAreaController
  before_filter :find_repositories

  def index
    @project = Project.new(params[:project])

    if request.post? && @project.save
        redirect_to :action => 'index'
    end
  end

  def edit
    @project = Project.find_by_short_name(params[:name])
    redirect_to :action => "index" and return if !@project
    @project.attributes = params[:project]
    @users = User.find(:all)

    if request.post?
      if params[:delete_mapping]
        user = User.find(params[:delete_mapping])
        @project.users.delete(user)
        redirect_to :project => @project, :action => 'edit'
      elsif params[:add_user] == "Add User"
        user = User.find(params[:user_project][:user_id])
        @project.users << user unless @project.users.include?(user)
        redirect_to :project => @project, :action => 'edit'
      elsif @project.save
        redirect_to :action => 'index'
      end
    end
  end
  
  def test_root_path # ajax
    if params[:repository_id].blank?
      result = "No repository selected."
    else
      if Repository.find(params[:repository_id]).fs.is_dir?(params[:root_path])
        result = "Success! Path is a directory in this repository."
      else
        result = "Failure! Path is not a directory in this repository."
      end
    end
    render :text => CGI::escapeHTML(result)
  end

  protected
    def find_repositories
      @repositories = Repository.find :all
    end

end
