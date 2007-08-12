require File.dirname(__FILE__) + '/../../spec_helper'

describe "/attachments/index.html.erb" do
  include AttachmentsHelper
  
  before do

    attachment_98 = mock_model(Attachment)

    attachment_99 = mock_model(Attachment)

    assigns[:attachments] = [attachment_98, attachment_99]
  end

  it "should render list of attachments" do
    render "/attachments/index.html.erb"

  end
end

