require File.dirname(__FILE__) + '/../../spec_helper'

describe "/attachments/edit.html.erb" do
  include AttachmentsHelper
  
  before do
    @attachment = mock_model(Attachment)

    assigns[:attachment] = @attachment
  end

  it "should render edit form" do
    render "/attachments/edit.html.erb"
    
    response.should have_tag("form[action=#{attachment_path(@attachment)}][method=post]") do

    end
  end
end


