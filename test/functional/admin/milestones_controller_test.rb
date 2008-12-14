require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/milestones_controller'

# Re-raise errors caught by the controller.
class Admin::MilestonesController; def rescue_action(e) raise e end; end

class Admin::MilestonesControllerTest < Test::Unit::TestCase
  def setup
    @controller = Admin::MilestonesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    assert_routing 'admin/milestones', :controller => 'admin/milestones', :action => 'index'
  end
end
