require File.dirname(__FILE__) + '/../../spec_helper'

describe "/attachments/show.html.erb" do
  include AttachmentsHelper
  
  before do
    
    @ticket = mock_model(Ticket)
    @ticket_comment = mock_model(TicketComment, :ticket => @ticket, :author_text => 'Bob', :created_at => Time.gm(2007, 8, 19, 21, 05, 00))
    @attachment = mock_model(Attachment, :filename => 'new_feature_patch.diff', :size => 1024, :ticket_comment => @ticket_comment, :public_filename => '../spec/fixtures/new_feature_patch.diff')
        
    assigns[:project] = mock_model(Project)
    assigns[:attachment] = @attachment
  end

  it "should render filename property" do
    render "/attachments/show.html.erb"
        
    response.should have_tag('dl') do
      with_tag('dt', 'Filename:')
      with_tag('dd', 'new_feature_patch.diff')
    end
  end
  
  it "should render size property"  
    render "/attachments/show.html.erb"
    
    response.should have_tag('dl') do
      with_tag('dt', 'Size:')
      with_tag('dd', '1 KB')
    end
  end
    
  it "should render uploaded by property"
    render "/attachments/show.html.erb"
  
    response.should have_tag('dl') do
      with_tag('dt', 'Uploaded By:')
      with_tag('dd', 'Bob')
    end
  end
    
  it "should render uploaded at propery"
    render "/attachments/show.html.erb"
  
    response.should have_tag('dl') do
      with_tag('dt', 'Uploaded At:')
      with_tag('dd', Time.gm(2007, 8, 19, 21, 05, 00).to_s)
    end
  end
end

