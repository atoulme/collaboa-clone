require File.dirname(__FILE__) + '/../../spec_helper'

describe "/attachments/new.html.erb" do
  include AttachmentsHelper
  
  before do
    @attachment = mock_model(Attachment)
    @attachment.stub!(:new_record?).and_return(true)

    assigns[:attachment] = @attachment
  end

  it "should render new form" do
    render "/attachments/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", attachments_path) do

    end
  end
end


