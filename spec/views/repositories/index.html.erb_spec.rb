require File.dirname(__FILE__) + '/../../spec_helper'

describe "/repositories/index.html.erb" do
  include RepositoriesHelper
  
  before do
    repository_98 = mock_model(Repository)
    repository_99 = mock_model(Repository)

    assigns[:repositories] = [repository_98, repository_99]
  end

  it "should render list of repositories" do
    render "/repositories/index.html.erb"
  end
end

