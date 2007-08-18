class MilestonesController < ApplicationController
  before_filter :load_project
  
  # GET /milestones
  # GET /milestones.xml
  def index
    ensure_user_has_permission_to :view_milestones
    
    @milestones = Milestone.find(:all)
    @resolved_status_ids = Status.resolved_status_ids.join(',')
    @unresolved_status_ids = Status.unresolved_status_ids.join(',')
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @milestones }
    end
  end

  # GET /milestones/new
  # GET /milestones/new.xml
  def new
    ensure_user_has_permission_to :add_milestones
    
    @milestone = Milestone.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @milestone }
    end
  end

  # GET /milestones/1/edit
  def edit
    ensure_user_has_permission_to :update_milestones
    
    @milestone = Milestone.find(params[:id])
  end

  # POST /milestones
  # POST /milestones.xml
  def create
    ensure_user_has_permission_to :add_milestones
    
    @milestone = Milestone.new(params[:milestone])

    respond_to do |format|
      if @milestone.save
        flash[:notice] = 'Milestone was successfully created.'
        format.html { redirect_to(@milestone) }
        format.xml  { render :xml => @milestone, :status => :created, :location => @milestone }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @milestone.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /milestones/1
  # PUT /milestones/1.xml
  def update
    ensure_user_has_permission_to :update_milestones
    
    @milestone = Milestone.find(params[:id])

    respond_to do |format|
      if @milestone.update_attributes(params[:milestone])
        flash[:notice] = 'Milestone was successfully updated.'
        format.html { redirect_to(@milestone) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @milestone.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /milestones/1
  # DELETE /milestones/1.xml
  def destroy
    ensure_user_has_permission_to :remove_milestones
    
    @milestone = Milestone.find(params[:id])
    @milestone.destroy

    respond_to do |format|
      format.html { redirect_to(milestones_url) }
      format.xml  { head :ok }
    end
  end
end
