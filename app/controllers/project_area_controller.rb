class ProjectAreaController < ApplicationController
  
  def authorized?
    current_project
  end
end
