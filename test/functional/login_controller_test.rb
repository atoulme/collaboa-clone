require File.dirname(__FILE__) + '/../test_helper'
require 'login_controller'

# Raise errors beyond the default web-based presentation
class LoginController; def rescue_action(e) raise e end; end

class LoginControllerTest < Test::Unit::TestCase
  fixtures :users, :projects, :user_projects
  
  def setup
    @controller = LoginController.new
    @request, @response = ActionController::TestRequest.new, ActionController::TestResponse.new
    @request.host = "localhost"
  end
  
  def test_auth_bob
    @request.session[:return_to] = "/bogus/location"

    login_as :bob
    assert(@response.has_session_object?(:user))

    assert_equal users(:bob).id, @response.session[:user]
    
    assert_equal("http://localhost/bogus/location", @response.redirect_url)
  end
  
  def test_login_default_redirect_when_one_project
    user = users(:existingbob)
    project = projects(:first_project)
    
    project.users << user
    assert_equal 1,  Project.show_for_user(user).length
    
    login_as user
    assert_redirected_to project_url(:project => project.short_name)
  end
  
  def test_login_default_redirect_when_multiple_projects
    user = users(:existingbob)
    Project.find(1).users << user
    Project.find(2).users << user
    assert_equal 2,  Project.show_for_user(user).length
    
    login_as user
    assert_redirected_to projects_url
  end

  def test_invalid_login
    login_as :bob, "not_correct"
     
    assert_nil assigns(:user)
    
    assert assigns(:message)
    assert assigns(:login)
  end
  
  def test_login_logoff
    login_as :bob
    assert(@response.has_session_object?(:user))

    get :logout
    assert_nil assigns(:user)
  end

  private
    def login_as(user, password='test')
      user = case user
      when User
        user
      when Symbol
        users(user)
      else
        User.find_by_login(user)
      end
      post :login, :user_login => user.login, :user_password => password
    end

end
