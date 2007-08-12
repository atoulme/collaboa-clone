require File.dirname(__FILE__) + '/../../spec_helper'

describe "/projects/show.html.erb" do
  include ProjectsHelper
  
  before do
    @project = mock_model(Project)

    assigns[:project] = @project
  end

  it "should render attributes in <p>" do
    render "/projects/show.html.erb"
  end
end

