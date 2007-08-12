require File.dirname(__FILE__) + '/../../spec_helper'

describe "/attachments/show.html.erb" do
  include AttachmentsHelper
  
  before do
    @attachment = mock_model(Attachment)


    assigns[:attachment] = @attachment
  end

  it "should render attributes in <p>" do
    render "/attachments/show.html.erb"

  end
end

