class AdminAreaController < ApplicationController
  before_filter CASClient::Frameworks::Rails::Filter
  before_filter :find_projects

 
  protected  
    
    def find_projects
      @projects = Project.find :all
    end

    def authorized?
      current_user && current_user.admin
    end

end
