require File.dirname(__FILE__) + '/../test_helper'
require 'admin/projects_controller'

# Re-raise errors caught by the controller.
class AdminController; def rescue_action(e) raise e end; end

class AdminControllerTest < Test::Unit::TestCase
  fixtures :projects, :users, :user_projects

  def setup
    @controller = Admin::ProjectsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @request.session[:user] = 1000001
  end

  def test_list_projects
    get :index

    assert_response :success
    assert_template 'index'

    assert_not_nil assigns(:projects)
    assert_equal 5, assigns(:projects).length
  end

  def test_edit_project
    get :edit, :project => "first:project"

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:project)
    assert assigns(:project).valid?

    assert_equal 0, assigns(:project).users.length 
  end


  def test_add_user_to_project
    post :edit, :add_user => "Add User", :project => "first:project", :user_project => { :user_id => 1 }
    
    assert_redirected_to :action => 'edit', :project => 'first:project'
    assert_equal 1, projects(:first_project).users.length
  end

  def test_remove_user_from_project
    projects(:first_project).users << users(:bob)
    assert_equal 1, projects(:first_project).users.length
    
    post :edit, :delete_mapping => users(:bob).id, :project => "first:project"

    assert_redirected_to :action => 'edit', :project => 'first:project'
    assert_equal 0, projects(:first_project).reload.users.length
  end

  def test_update_project
    post :edit, :project => "first:project"
    assert_response :redirect
    assert_redirected_to :action => 'index'
  end

  def test_new_project
    post :index, :project => { :name => "fourth project", :info => "new" }
    assert_response :redirect
    assert_redirected_to :action => 'index'

    project = Project.find(:first,:conditions => ["info = ?","new"])
    assert_equal "new", project.info
  end
  
end
