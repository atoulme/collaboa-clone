require File.dirname(__FILE__) + '/../../spec_helper'

describe "/milestones/index.html.erb" do
  include MilestonesHelper
  
  before do
    milestone_98 = mock_model(Milestone)
    milestone_99 = mock_model(Milestone)

    assigns[:milestones] = [milestone_98, milestone_99]
  end

  it "should render list of milestones" do
    render "/milestones/index.html.erb"
  end
end

