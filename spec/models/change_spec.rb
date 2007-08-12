require File.dirname(__FILE__) + '/../spec_helper'

describe Change do
  before(:each) do
    @change = Change.new
  end

  it "should be valid" do
    @change.should be_valid
  end
end
