require File.dirname(__FILE__) + '/../../spec_helper'

describe "/repositories/show.html.erb" do
  include RepositoriesHelper
  
  before do
    @repository = mock_model(Repository)

    assigns[:repository] = @repository
  end

  it "should render attributes in <p>" do
    render "/repositories/show.html.erb"
  end
end

