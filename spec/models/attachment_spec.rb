require File.dirname(__FILE__) + '/../spec_helper'

describe Attachment do
  before(:each) do
    @attachment = Attachment.new
  end

  it "should be valid" do
    @attachment.should be_valid
  end
end
