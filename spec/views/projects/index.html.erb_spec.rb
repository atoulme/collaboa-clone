require File.dirname(__FILE__) + '/../../spec_helper'

describe "/projects/index.html.erb" do
  include ProjectsHelper
  
  before do
    project_98 = mock_model(Project)
    project_99 = mock_model(Project)

    assigns[:projects] = [project_98, project_99]
  end

  it "should render list of projects" do
    render "/projects/index.html.erb"
  end
end

