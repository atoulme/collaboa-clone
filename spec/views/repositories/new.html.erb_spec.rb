require File.dirname(__FILE__) + '/../../spec_helper'

describe "/repositories/new.html.erb" do
  include RepositoriesHelper
  
  before do
    @repository = mock_model(Repository)
    @repository.stub!(:new_record?).and_return(true)
    assigns[:repository] = @repository
  end

  it "should render new form" do
    render "/repositories/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", repositories_path) do
    end
  end
end


