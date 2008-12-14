class MilestonesController < ProjectAreaController

  def index
    @milestones = if current_project
      current_project.milestones.find_all_by_completed(false)
    else
      Milestone.find_all_by_completed(false)
    end
    
    @milestones = @milestones.sort_by {|m| [m.due_at || Time.gm(2038), 100 - m.completed_tickets_percent, m.created_at]}
        
  end
  
  def show
    @milestone = Milestone.find(params[:id])
  end  

  def create
    return unless request.post?
    milestone = Milestone.new(params[:milestone])
    milestone.project = current_project
    milestone.save!
    flash[:notice] = "The milestone was successfully created"
    redirect_to :controller => "milestones", :action => "index", :project => current_project
  end


  def edit
    @milestone = Milestone.find_by_id(params[:id])
    return unless request.post?
    @milestone.attributes = params[:milestone]
    @milestone.save!
    flash[:notice] = "The milestone was successfully modified"
    redirect_to :controller => "milestones", :action => "index", :project => current_project
  end

  def authorized?
    return false if !current_project
    return (current_user and current_user.rights_for(current_project) and current_user.rights_for(current_project).project_admin) if %w[create edit].include? params[:action]
    true
  end 
end
