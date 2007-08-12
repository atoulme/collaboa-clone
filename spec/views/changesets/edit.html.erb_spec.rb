require File.dirname(__FILE__) + '/../../spec_helper'

describe "/changesets/edit.html.erb" do
  include ChangesetsHelper
  
  before do
    @changeset = mock_model(Changeset)
    assigns[:changeset] = @changeset
  end

  it "should render edit form" do
    render "/changesets/edit.html.erb"
    
    response.should have_tag("form[action=#{changeset_path(@changeset)}][method=post]") do
    end
  end
end


