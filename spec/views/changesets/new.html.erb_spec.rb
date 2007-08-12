require File.dirname(__FILE__) + '/../../spec_helper'

describe "/changesets/new.html.erb" do
  include ChangesetsHelper
  
  before do
    @changeset = mock_model(Changeset)
    @changeset.stub!(:new_record?).and_return(true)
    assigns[:changeset] = @changeset
  end

  it "should render new form" do
    render "/changesets/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", changesets_path) do
    end
  end
end


