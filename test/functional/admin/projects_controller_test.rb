require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/projects_controller'

# Re-raise errors caught by the controller.
class Admin::ProjectsController; def rescue_action(e) raise e end; end

class Admin::ProjectsControllerTest < Test::Unit::TestCase
  fixtures :projects, :users, :repositories

  def setup
    @controller = Admin::ProjectsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @request.session[:user] = 1000001
  end

  def test_root_path_checking
    xml_http_request :post, :test_root_path, {"root_path"=>"foo", "repository_id"=>""}
    assert_response :success
    assert_match "No repository selected", @response.body
    
    xml_http_request :post, :test_root_path, {"root_path"=>"foo", "repository_id"=>"1"}
    assert_response :success
    assert_match "Failure", @response.body
    
    xml_http_request :post, :test_root_path, {"root_path"=>"project4", "repository_id"=>"1"}
    assert_match "Success", @response.body
  end
end
