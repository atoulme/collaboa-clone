require File.dirname(__FILE__) + '/../spec_helper'

describe TicketAttribute do
  before(:each) do
    @ticket_attribute = TicketAttribute.new
  end

  it "should be valid" do
    @ticket_attribute.should be_valid
  end
end
