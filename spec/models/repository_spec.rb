require File.dirname(__FILE__) + '/../spec_helper'

describe Repository do
  before(:each) do
    @repository = Repository.new
  end

  it "should be valid" do
    @repository.should be_valid
  end
end
