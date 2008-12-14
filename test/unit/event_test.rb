require File.dirname(__FILE__) + '/../test_helper'

class EventTest < Test::Unit::TestCase
  fixtures :events

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Event, events(:first)
  end
end
