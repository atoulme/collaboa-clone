require File.dirname(__FILE__) + '/../../test_helper'
require 'admin/users_controller'

# Re-raise errors caught by the controller.
class Admin::UsersController; def rescue_action(e) raise e end; end

class Admin::UsersControllerTest < Test::Unit::TestCase
  fixtures :users
  
  def setup
    @controller = Admin::UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    
    @request.session[:user] = 1000001
  end

  def test_index
    get :index
    assert_response :success
  end

  # Replace this with your real tests.
  def test_delete
    # existingbob exists
    existingbob = users(:existingbob)
    assert_not_nil existingbob
    # delete existingbob
    post :delete, :id => users(:existingbob).id
    assert_redirected_to :action => 'index'
    # make sure existingbob was deleted
    assert !User.exists?(existingbob.id)
  end
end
