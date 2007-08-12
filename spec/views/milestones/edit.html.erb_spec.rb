require File.dirname(__FILE__) + '/../../spec_helper'

describe "/milestones/edit.html.erb" do
  include MilestonesHelper
  
  before do
    @milestone = mock_model(Milestone)
    assigns[:milestone] = @milestone
  end

  it "should render edit form" do
    render "/milestones/edit.html.erb"
    
    response.should have_tag("form[action=#{milestone_path(@milestone)}][method=post]") do
    end
  end
end


