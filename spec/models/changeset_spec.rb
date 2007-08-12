require File.dirname(__FILE__) + '/../spec_helper'

describe Changeset do
  before(:each) do
    @changeset = Changeset.new
  end

  it "should be valid" do
    @changeset.should be_valid
  end
end
