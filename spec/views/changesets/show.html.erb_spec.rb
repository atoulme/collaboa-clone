require File.dirname(__FILE__) + '/../../spec_helper'

describe "/changesets/show.html.erb" do
  include ChangesetsHelper
  
  before do
    @changeset = mock_model(Changeset)

    assigns[:changeset] = @changeset
  end

  it "should render attributes in <p>" do
    render "/changesets/show.html.erb"
  end
end

