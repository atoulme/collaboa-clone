require File.dirname(__FILE__) + '/../test_helper'

class SeverityTest < Test::Unit::TestCase
  fixtures :severities

  def setup
    @severity = Severity.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Severity,  @severity
  end
end
