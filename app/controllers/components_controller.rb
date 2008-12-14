class ComponentsController < ApplicationController
  def index

  end

  def create
    return unless request.post?
    component = Part.new(params[:component])
    component.project = current_project
    component.save!
    flash[:notice] = "The component was successfully created"
    redirect_to :controller => "components", :action => "index", :project => current_project
  end


  def edit
    @component = Part.find_by_id(params[:id])
    return unless request.post?
    @component.attributes = params[:component]
    @component.save!
    flash[:notice] = "The component was successfully modified"
    redirect_to :controller => "components", :action => "index", :project => current_project
  end

  def delete
    component = Part.find_by_id(params[:id])
    component.destroy
    flash[:notice] = "The component was successfully deleted"
    redirect_to :controller => "components", :action => "index", :project => current_project
  end 

  def authorized?
    return false if !current_project
    return (current_user and current_user.rights_for(current_project) and current_user.rights_for(current_project).project_admin) if %w[create edit delete].include? params[:action]
    true
  end 
end
