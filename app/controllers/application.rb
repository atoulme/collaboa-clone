class ApplicationController < ActionController::Base  

  before_filter :redirect_if_unauthorized
 
  layout 'application' 
  #before_filter :set_headers
  after_filter :remember_location

  def url_for_svn_path(fullpath, rev=nil)
    if current_project
      relative_path = current_project.relativize_svn_path(fullpath)
    else
      relative_path = fullpath
    end
    path_parts = relative_path.split('/').reject {|part| part.empty?}
    path_url = {:controller => 'repository', :action => 'browse', :path => path_parts}
    if rev
      url = path_url.merge({:rev => rev})
    else
      url = path_url
    end
    url_for(url)
  end
  helper_method :url_for_svn_path

  def current_user
    if session[:cas_user]
      return session[:user] if (session[:user] and session[:user].login == session[:cas_user])
      session[:user] = Project.find_by_login(session[:cas_user])
    else
      session[:user] = nil
    end
    session[:user]
  end

  def current_user
    User.find_by_login(session[:cas_user]) if session[:cas_user]
  end

  helper_method :current_user
  
  def rescue_action_in_public(exception)
    render :template => 'rescues/error'
  end

  def current_project
    if params[:project] && (params[:project].is_a? String)
      return session[:project] if (session[:project] and session[:project].to_param == params[:project])
      session[:project] = Project.find(:first, :conditions => [ "short_name = ?", params[:project]])
    end
    session[:project]
  end

  helper_method :current_project

  def authorized?
    true
  end

  private  

    def redirect_if_unauthorized
      if !authorized?
        flash[:notice] = "You are not authorized to browse this space. Please <a href='#{url_for :controller => 'main', :action => 'login'}'>login</a>."
        redirect_to :controller => "main", :action => "index", :project => current_project
      end
    end

    # Sets the headers for each request
    def set_headers
    	headers['Content-Type'] = "text/html; charset=utf-8" 
    end
    
    # Remember where we are.
    # Never return to one of these controllers: 
    @@remember_not = ['feed', 'login', 'user']
    def remember_location 
    	if response.headers['Status'] == '200 OK' 
    		session['return_to'] = request.request_uri unless @@remember_not.include? controller_name 
    	end
    end
    
    def sync_with_repos
      Changeset.sync_changesets
    end
end
