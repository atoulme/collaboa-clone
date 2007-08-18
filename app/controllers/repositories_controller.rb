class RepositoriesController < ApplicationController
  before_filter :load_project
  before_filter :set_path
  before_filter :set_revision
  
  # GET /repositories
  # GET /repositories.xml
  def index
    @repositories = Repository.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @repositories }
    end
  end

  # GET /repositories/1
  # GET /repositories/1.xml
  def show
    ensure_user_has_permission_to(:view_repository)
    @repository = @project.repository
    
    @node = @repository.backend.node(@path, @revision)
    
    if @node.dir?
      @nodes = @node.entries
      @nodes.sort!{ |x,y| x.name.downcase <=> y.name.downcase }
      @nodes.sort!{ |x,y| y.dir?.to_s <=> x.dir?.to_s }
    else
      
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @repository }
    end
  rescue Svn::Error::FS_NOT_FOUND, Svn::Error::FS_NO_SUCH_REVISION
    render(:text => "Not Found\n", :status => 404)
  end

  # GET /repositories/new
  # GET /repositories/new.xml
  def new
    @repository = Repository.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @repository }
    end
  end

  # GET /repositories/1/edit
  def edit
    @repository = Repository.find(params[:id])
  end

  # POST /repositories
  # POST /repositories.xml
  def create
    @repository = Repository.new(params[:repository])

    respond_to do |format|
      if @repository.save
        flash[:notice] = 'Repository was successfully created.'
        format.html { redirect_to(@repository) }
        format.xml  { render :xml => @repository, :status => :created, :location => @repository }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @repository.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /repositories/1
  # PUT /repositories/1.xml
  def update
    @repository = Repository.find(params[:id])

    respond_to do |format|
      if @repository.update_attributes(params[:repository])
        flash[:notice] = 'Repository was successfully updated.'
        format.html { redirect_to(@repository) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @repository.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /repositories/1
  # DELETE /repositories/1.xml
  def destroy
    @repository = Repository.find(params[:id])
    @repository.destroy

    respond_to do |format|
      format.html { redirect_to(repositories_url) }
      format.xml  { head :ok }
    end
  end
  
  protected
  def set_path
    if params[:path]
      @path = File.join(params[:path])
    else
      @path = '/'
    end
  end
  
  def set_revision
    @revision = params[:rev] ? params[:rev].to_i : nil
  end
end
