require File.dirname(__FILE__) + '/../test_helper'
require 'repository_controller'

if Collaboa::CONFIG.subversion_support
  
# Re-raise errors caught by the controller.
class RepositoryController; def rescue_action(e) raise e end; end

class RepositoryControllerTest < Test::Unit::TestCase
  fixtures :projects, :repositories

  def setup
    @controller = RepositoryController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end
  
  def test_view_changesets
    assert_routing '/first%3Aproject/repository/changesets', :controller => 'repository', :action => 'changesets', :project => 'first:project'
    get :changesets, :project => "first:project"
    assert_response :success
    assert_template 'changesets'
    assert_equal 12, assigns(:changesets).size
  end
  
  def test_view_changesets_for_project
    get :changesets, :project => "fourth:project"
    assert_response :success
    assert_equal 1, assigns(:changesets).size
  end
  
  def test_view_changesets_without_project
    get :changesets
    assert_response :success
    assert_equal 12, assigns(:changesets).size
  end
  
  def test_show_changeset
    assert_routing '/first%3Aproject/repository/changesets/1', :controller => 'repository', :action => 'show_changeset', :project => 'first:project', :revision => '1'
    get :show_changeset, 'revision' => "3", :project => "first:project"
    assert_template 'show_changeset'
    assert_response :success
    assert_equal "edited file1.txt again", assigns(:changeset).log
    assert_equal 1, assigns(:changeset).changes.size
  end
  
  def test_index
    assert_routing '/first%3Aproject', :controller => 'repository', :action => 'index', :project => 'first:project'
    get :index, :project => "first:project"
    assert_response :redirect
    assert_redirected_to(:action => 'changesets')
  end

  def test_browse
    assert_routing '/first%3Aproject/repository/browse', :controller => 'repository', :action => 'browse', :project => 'first:project', :path => []
    get :browse, 'path' => [], :project => "first:project"
    assert_response :success
    assert_template 'browse'
    
    r = get :browse, 'path' => ["html"], :project => "first:project"
    assert_response :success
    assert_template 'browse'
  end
  
  def test_browse_project_rooted_in_subdirectory
    assert_routing '/fourth%3Aproject/repository/browse', :controller => 'repository', :action => 'browse', :project => 'fourth:project', :path => []
    get :browse, 'path' => [], :project => "fourth:project"
    assert_equal 'project4/', assigns(:current_entry).path
    
    assert_routing '/fourth%3Aproject/repository/browse/trunk', :controller => 'repository', :action => 'browse', :project => 'fourth:project', :path => ['trunk']
    get :browse, 'path' => ['trunk'], :project => "fourth:project"
    assert_equal 'project4/trunk', assigns(:current_entry).path
  end
  
  def test_browse_file
    get :browse, 'path' => ["file.txt"], :project => "first:project"
    assert_response :redirect
    assert_redirected_to(:action => 'view_file')
    
    assert_routing '/first%3Aproject/repository/file/file.txt', :controller => 'repository', :action => 'view_file', :project => 'first:project', :path => ['file.txt']
    get :view_file, 'path' => ["file.txt"], :project => "first:project"
    assert_response :success
    assert_template 'showfile'
    assert_equal "I am the silly test file!\n", assigns(:file).contents
  end
  
  def test_browse_file_with_project_rooted_in_subdirectory
    get :browse, 'path' => ["README"], :project => "fourth:project"
    assert_response :redirect
    assert_redirected_to(:action => 'view_file')
    
    assert_routing '/fourth%3Aproject/repository/file/README', :controller => 'repository', :action => 'view_file', :project => 'fourth:project', :path => ['README']
    get :view_file, 'path' => ["README"], :project => "fourth:project"
    assert_response :success
    assert_template 'showfile'
    assert_equal "Some people keep many projects in the same repository.  This is one example.\n", assigns(:file).contents
  end
  
  def test_alternative_formats
    get :view_file, 'path' => ["file.txt"], :format => 'txt', :project => "first:project"
    assert_response :success
    
    get :view_file, 'path' => ["file.txt"], :format => 'raw', :project => "first:project"
    assert_response :success
  end

  def test_index_when_no_repository
    # redirect to tickets when there is no repository
    get :index, :project => "no:repos:project"
    assert_redirected_to project_url(:controller => 'tickets')
  end

#   def test_routes
#     # file viewer
#     wanted_file = { :controller => 'repository', :action => 'view_file', :path => ["file.txt"] }
#     #assert_generates "repository/file/file1.txt", wanted_file
#     assert_recognizes wanted_file, "repository/file/file.txt"
#     
#     # file view2
#     wanted_file = { :controller => 'repository', :action => 'view_file', :path => ["html", "html_file.html"] }
#     #assert_generates "repository/file/file1.txt", wanted_file
#     assert_recognizes wanted_file, "repository/file/html/html_file.html"
#     
#     # browser
#     wanted_dir = { :controller => 'repository', :action => 'browse', :path => ["html"] }
#     #assert_generates "repository/browse/html", wanted_dir
#     assert_recognizes wanted_dir, "repository/browse/html"
#     
#     # a specific changeset
#     wanted = { :controller => 'repository', :action => 'show_changeset', :revision => "1" }
#     #assert_generates "repository/changesets/1", wanted
#     assert_recognizes wanted, "repository/changesets/1"
#   end
end

end
