require File.dirname(__FILE__) + '/../../spec_helper'

describe "/tickets/index.html.erb" do
  include TicketsHelper
  
  before do
    ticket_98 = mock_model(Ticket)
    ticket_99 = mock_model(Ticket)

    assigns[:tickets] = [ticket_98, ticket_99]
  end

  it "should render list of tickets" do
    render "/tickets/index.html.erb"
  end
end

