require File.dirname(__FILE__) + '/../test_helper'
require 'search_controller'

# Re-raise errors caught by the controller.
class SearchController; def rescue_action(e) raise e end; end

class SearchControllerTest < Test::Unit::TestCase
  fixtures :projects, :tickets, :ticket_changes, :changesets
  def setup
    @controller = SearchController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_search_without_query
    get :index, :project => projects(:first_project).short_name
    assert_response :success
    assert_template 'index'
  end
  
  def test_search_without_project
    get :index
    assert_response :success
    assert_template 'index'
  end
  
  def test_search_with_query
    project = projects(:first_project)
    get :index, :project => project.short_name, :q => 'test'
    assert_response :success
    assert_template 'index'
    assert_equal 4, assigns(:found_items).flatten.size
    
    project = projects(:second_project)
    get :index, :project => project.short_name, :q => 'test'
    assert_equal 2, assigns(:found_items).flatten.size    
    assert_response :success
  end
  
  def test_search_query_across_all_projects
    get :index, :q => 'test'
    assert_response :success
    assert_template 'index'
    assert_equal 6, assigns(:found_items).flatten.size
  end
end
