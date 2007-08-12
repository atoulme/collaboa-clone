require File.dirname(__FILE__) + '/../../spec_helper'

describe "/milestones/new.html.erb" do
  include MilestonesHelper
  
  before do
    @milestone = mock_model(Milestone)
    @milestone.stub!(:new_record?).and_return(true)
    assigns[:milestone] = @milestone
  end

  it "should render new form" do
    render "/milestones/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", milestones_path) do
    end
  end
end


