require File.dirname(__FILE__) + '/../test_helper'
require 'milestones_controller'

# Re-raise errors caught by the controller.
class MilestonesController; def rescue_action(e) raise e end; end

class MilestonesControllerTest < Test::Unit::TestCase
  fixtures :projects, :milestones

  def setup
    @controller = MilestonesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_get_index
    get :index, :project => "first:project"
    assert_response :success
    assert_template 'index'
    assert assigns(:milestones)
  end
  
  def test_get_index_without_project
    get :index
    assert_response :success
    assert_equal Milestone.count, assigns(:milestones).length
  end

  def test_get_index_with_project
    project = Project.new
    project.short_name = "name1"
    project.save

    project2 = Project.new
    project2.short_name = "name2"
    project2.save

    milestone = Milestone.new
    milestone.project = project
    milestone.name = "milestone"
    milestone.info = "info"
    milestone.completed = false
    milestone.save

    get :index, :project => project.short_name
    assert_response :success
    assert_template 'index'
    assert_equal 1, assigns(:milestones).length

    get :index, :project => project2.short_name
    assert_response :success
    assert_template 'index'
    assert_equal 0, assigns(:milestones).length
  end
end
