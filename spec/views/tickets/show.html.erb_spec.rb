require File.dirname(__FILE__) + '/../../spec_helper'

describe "/tickets/show.html.erb" do
  include TicketsHelper
  
  before do
    @ticket = mock_model(Ticket)

    assigns[:ticket] = @ticket
  end

  it "should render attributes in <p>" do
    render "/tickets/show.html.erb"
  end
end

