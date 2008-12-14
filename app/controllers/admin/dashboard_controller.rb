class Admin::DashboardController < AdminAreaController

  def index
    #You are entering an area where no project is concerned, so forget about your current project
    session[:project] = nil
  end
  
end
