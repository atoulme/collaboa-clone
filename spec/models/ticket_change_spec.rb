require File.dirname(__FILE__) + '/../spec_helper'

describe TicketChange do
  before(:each) do
    @ticket_change = TicketChange.new
  end

  it "should be valid" do
    @ticket_change.should be_valid
  end
end
