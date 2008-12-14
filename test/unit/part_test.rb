require File.dirname(__FILE__) + '/../test_helper'

class PartTest < Test::Unit::TestCase
  fixtures :parts

  def setup
    @part = Part.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Part,  @part
  end
end
