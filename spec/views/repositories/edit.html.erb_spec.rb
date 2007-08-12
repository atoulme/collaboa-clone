require File.dirname(__FILE__) + '/../../spec_helper'

describe "/repositories/edit.html.erb" do
  include RepositoriesHelper
  
  before do
    @repository = mock_model(Repository)
    assigns[:repository] = @repository
  end

  it "should render edit form" do
    render "/repositories/edit.html.erb"
    
    response.should have_tag("form[action=#{repository_path(@repository)}][method=post]") do
    end
  end
end


