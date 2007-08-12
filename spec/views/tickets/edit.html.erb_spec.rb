require File.dirname(__FILE__) + '/../../spec_helper'

describe "/tickets/edit.html.erb" do
  include TicketsHelper
  
  before do
    @ticket = mock_model(Ticket)
    assigns[:ticket] = @ticket
  end

  it "should render edit form" do
    render "/tickets/edit.html.erb"
    
    response.should have_tag("form[action=#{ticket_path(@ticket)}][method=post]") do
    end
  end
end


