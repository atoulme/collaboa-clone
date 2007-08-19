class MilestonesController < ApplicationController
  before_filter :load_project
  
  # GET /milestones
  # GET /milestones.xml
  def index
    ensure_user_has_permission_to :view_milestones
    
    @milestones = @project.milestones.find(:all)
    @resolved_status_ids = Status.resolved_status_ids.join(',')
    @unresolved_status_ids = Status.unresolved_status_ids.join(',')
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @milestones }
    end
  end
end
