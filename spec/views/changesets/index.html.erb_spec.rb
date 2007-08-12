require File.dirname(__FILE__) + '/../../spec_helper'

describe "/changesets/index.html.erb" do
  include ChangesetsHelper
  
  before do
    changeset_98 = mock_model(Changeset)
    changeset_99 = mock_model(Changeset)

    assigns[:changesets] = [changeset_98, changeset_99]
  end

  it "should render list of changesets" do
    render "/changesets/index.html.erb"
  end
end

