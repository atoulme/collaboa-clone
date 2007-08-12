require File.dirname(__FILE__) + '/../../spec_helper'

describe "/milestones/show.html.erb" do
  include MilestonesHelper
  
  before do
    @milestone = mock_model(Milestone)

    assigns[:milestone] = @milestone
  end

  it "should render attributes in <p>" do
    render "/milestones/show.html.erb"
  end
end

