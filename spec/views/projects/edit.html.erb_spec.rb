require File.dirname(__FILE__) + '/../../spec_helper'

describe "/projects/edit.html.erb" do
  include ProjectsHelper
  
  before do
    @project = mock_model(Project)
    assigns[:project] = @project
  end

  it "should render edit form" do
    render "/projects/edit.html.erb"
    
    response.should have_tag("form[action=#{project_path(@project)}][method=post]") do
    end
  end
end


