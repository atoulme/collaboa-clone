class RepositoryController < ProjectAreaController
  before_filter :sync_with_repos
  layout 'application', :except => ['send_data_to_browser']
  before_filter :setup_repository
  
  def index
    redirect_to :action => 'changesets'
  end
  
  def browse
    @path = params[:path].join("/")
    if current_project.repository.fs.is_dir?(@path)
      @current_entry = current_project.repository.fs.get_node_entry(@path, @rev)
      @node_entries = @current_entry.entries
      @node_entries.sort!{ |x,y| x.name.downcase <=> y.name.downcase }
      @node_entries.sort!{ |x,y| x.type <=> y.type } 
      GC.start
    else 
      redirect_to :action => 'view_file', :path => params[:path]
    end
  end
  
  # TODO: check so that filesize is reasonable, before doing anything
  def view_file
    if current_project.repository.fs.is_dir?(@path)
      redirect_to :action => 'browse', :path => params[:path]
    else
      @file = current_project.repository.fs.get_node_entry(@path, @rev)
      if params[:format] == 'raw'
        send_data @file.contents, :name => @path
      elsif params[:format] == 'txt'
        send_data @file.contents, :type => "text/plain", :disposition => 'inline'
      else      
        if @file.is_textual?                             
          render :action => 'showfile'
        elsif @file.is_image?
          render :action => 'showimage'
        else
          render :action => 'showunknown'
        end
      end
    end
  end
  
  def changesets
    @changesets = Changeset.paginate({:page => params[:page], :per_page => 15}.merge(Changeset.options_for_pagination(current_project)))
  end
  
  def show_changeset
    @changeset = Changeset.find_by_revision_and_repository_id(params[:revision], current_project.repository.id)    
    
    if @changeset.nil?
      redirect_to :action => 'changesets'
    else
      @files_to_diff = @changeset.changes.reject {|change|  change.name != 'M' }
      @files_to_diff.reject! {|f| !f.diffable? }
    end
  end
  
  def revisions
    logger.debug "** PATH: #{@path}"
    redirect_to :action => 'browse' if @path.empty?
    @changes = Change.find_all_by_path_and_repository_id(@path, current_project.repository.id, :order => 'created_at DESC', :include => :changeset)
  end

  def send_data_to_browser
    file = current_project.repository.fs.get_node_entry(@path, @rev)
    send_data file.contents, :type => file.mime_type, :disposition => 'inline'
  end
  
  private  
    
    def setup_repository
      @rev = params[:rev]
      @path = (params[:path] && (params[:path].is_a? Array)) ? params[:path].join("/") : params[:path]
      if current_project
        #@path = current_project.absolutize_svn_path(params[:path])
        unless (!@path || ((@path.start_with? current_project.root_path) || ((@path + "/").start_with? current_project.root_path)))
          redirect_to :controller => 'main', :project => current_project
          return
        end
      end
    end
end
