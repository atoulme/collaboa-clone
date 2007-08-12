require File.dirname(__FILE__) + '/../../spec_helper'

describe "/tickets/new.html.erb" do
  include TicketsHelper
  
  before do
    @ticket = mock_model(Ticket)
    @ticket.stub!(:new_record?).and_return(true)
    assigns[:ticket] = @ticket
  end

  it "should render new form" do
    render "/tickets/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", tickets_path) do
    end
  end
end


