require File.dirname(__FILE__) + '/../test_helper'

class StatusTest < Test::Unit::TestCase
  fixtures :status

  def setup
    @status = Status.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Status,  @status
  end
end
