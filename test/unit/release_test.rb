require File.dirname(__FILE__) + '/../test_helper'

class ReleaseTest < Test::Unit::TestCase
  fixtures :releases

  def setup
    @release = Release.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Release,  @release
  end
end
