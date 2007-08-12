class ChangesetsController < ApplicationController
  before_filter :load_project
    
  # GET /changesets
  # GET /changesets.xml
  def index
    ensure_user_has_permission_to :view_changesets
    
    @changesets = @project.changesets.paginate(:page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @changesets }
    end
  end

  # GET /changesets/1
  # GET /changesets/1.xml
  def show
    ensure_user_has_permission_to :view_changesets
    
    @changeset = @project.changesets.find_by_revision(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @changeset }
    end
  end

  # POST /changesets.xml
  def create
    ensure_user_has_permission_to :add_changesets
    
    @changeset = Changeset.new(params[:changeset])

    respond_to do |format|
      if @changeset.save
        format.xml  { render :xml => @changeset, :status => :created, :location => @changeset }
      else
        format.xml  { render :xml => @changeset.errors, :status => :unprocessable_entity }
      end
    end
  end
end
