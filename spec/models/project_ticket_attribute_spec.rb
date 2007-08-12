require File.dirname(__FILE__) + '/../spec_helper'

describe ProjectTicketAttribute do
  before(:each) do
    @project_ticket_attribute = ProjectTicketAttribute.new
  end

  it "should be valid" do
    @project_ticket_attribute.should be_valid
  end
end
