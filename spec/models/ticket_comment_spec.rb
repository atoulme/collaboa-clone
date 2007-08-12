require File.dirname(__FILE__) + '/../spec_helper'

describe TicketComment do
  before(:each) do
    @ticket_comment = TicketComment.new
  end

  it "should be valid" do
    @ticket_comment.should be_valid
  end
end
