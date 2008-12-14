require File.dirname(__FILE__) + '/../test_helper'
require 'rss_controller'

# Re-raise errors caught by the controller.
class RssController; def rescue_action(e) raise e end; end

class RssControllerTest < Test::Unit::TestCase
  def setup
    @controller = RssController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

   def test_index
    get :index
    assert_response :success
    assert_template 'index'
   end
 
   def test_rss_all
     get :all
     assert_response :success
     assert_template 'rss'
   end
 
   def test_rss_tickets
     assert_routing 'rss/tickets', :controller => 'rss', :action => 'tickets'
     
     get :tickets
     assert_response :success
     assert_template 'rss/rss'
   end
   
   def test_rss_changesets
     get :changesets
     assert_response :success
     assert_template 'rss'
   end
end
