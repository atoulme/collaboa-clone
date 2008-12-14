require File.dirname(__FILE__) + '/../test_helper'

class ChangeTest < Test::Unit::TestCase
  fixtures :changes

  def setup
    @change = Change.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Change,  @change
  end
end
