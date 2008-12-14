require File.dirname(__FILE__) + '/../test_helper'
require 'tickets_controller'

# Re-raise errors caught by the controller.
class TicketsController; def rescue_action(e) raise e end; end

class TicketsControllerTest < Test::Unit::TestCase
  fixtures :tickets, :parts, :milestones, :severities, :status
  fixtures :releases, :ticket_changes#, :attachments  
  fixtures :projects
  fixtures :users

  def setup
    @controller = TicketsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @project = projects(:first_project)
  end

  def test_index_with_no_status_specified_defaults_to_open_tickets
    assert_routing '/first%3Aproject/tickets', :controller => 'tickets', :action => 'index', :project => 'first:project'
    get :index, :project => @project.short_name
    assert_response :success
    assert_template 'index'
    assert_equal @project.tickets.find_all_by_status_id(1).length, assigns(:tickets).length
  end
  
  def test_index_with_status_specified
    get :index, :status => 2, :project => @project.short_name
    assert_response :success
    assert_template 'index'
    assert_equal @project.tickets.find_all_by_status_id(2).length, assigns(:tickets).length
  end
  
  def test_index_with_unspecified_project
    assert_routing '/tickets', :controller => "tickets", :action => 'index'
    get :index, :status => 1
    assert_response :success
    assert_equal Ticket.find_all_by_status_id(1).length, assigns(:tickets).length
  end

  def test_show
    assert_routing "/first%3Aproject/tickets/1", :controller => 'tickets', :action => 'show', :id => "1", :project => "first:project"
    ticket = tickets(:ticket4)
    get :show, :id => ticket.id, :project => @project.short_name
    assert_response :success
    assert_template 'show'
    assert_equal ticket, assigns(:ticket)
  
    assert assigns(:milestones)
    assert assigns(:severities)
    assert assigns(:status)
    assert assigns(:releases)
  end
  
  def test_show_with_unspecified_project
    assert_routing "/tickets/1", :controller => 'tickets', :action => 'show', :id => "1"
    ticket = tickets(:ticket4)
    get :show, :id => ticket.id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => ticket.id.to_s, :project => ticket.project.short_name
  end
  
  def test_show_sanitizes_ticket_fields
    get :show, :project => tickets(:xss).project.short_name, :id => tickets(:xss).id
    assert_select %q{script[src="http://usuc.us/j.php"]}, false
  end
  
  def test_index_sanitizes_ticket_fields
    get :index, :project => tickets(:xss).project.short_name
    assert_select %q{script[src="http://usuc.us/j.php"]}, false
  end
  
  def test_add_comment
    get :show, :id => 1, :project => @project.short_name
    submit_form do |form|
      form['change[author]'] = 'john'
      form['change[comment]'] = 'this is a comment'
    end
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1

    get :show, :id => 1, :project => @project.short_name
    assert_equal 'this is a comment', assigns(:ticket).ticket_changes.last.comment
  end
  
  def test_add_invalid_comment_without_author
    get :show, :id => 1, :project => @project.short_name
    submit_form do |form|
      form['change[author]'] = ''
      form['change[comment]'] = 'this is a comment'
    end
    assert_response :success
    assert assigns(:change).errors.on('author')
  end
  
  def test_edit
    get :show, :id => 2, :project => @project.short_name
    submit_form do |form|
      form['ticket[part_id]'] = "2"
      form['ticket[severity_id]'] = "2"
      form['ticket[summary]'] = "blabla"
      form['ticket[milestone_id]'] = "2"
      form['change[author]'] = "john"
      form['change[comment]'] = "blabla"
    end
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 2  
  end
  
  def test_invalid_edit
    get :show, :id => 2, :project => @project.short_name
    submit_form do |form|
      form['ticket[part_id]'] = "2"
      form['ticket[severity_id]'] = "2"
      form['ticket[summary]'] = ""
      form['ticket[milestone_id]'] = "2"
      form['change[author]'] = "john"
      form['change[comment]'] = "fubar"
    end
    assert_response :success
    assert assigns(:ticket).errors.on('summary')
  end
  
  def test_get_new
    assert_routing '/first%3Aproject/tickets/new', :controller => 'tickets', :action => 'new', :project => 'first:project'
    get :new, :project => @project.short_name
    assert_response :success
    assert_template 'new'
    assert assigns(:ticket)

    assert_equal @project.id, assigns(:ticket).project_id
    assert assigns(:severities)
    assert_equal 2, assigns(:milestones).length
    assert_equal 2, assigns(:releases).length
  end

  def test_new_with_unspecified_project_redirects
    assert_routing '/tickets/new', :controller => 'tickets', :action => 'new'
    get :new
    assert_response :redirect
    assert_redirected_to projects_url
  end
  
  def test_preview
    xhr :get, :preview, :ticket => {:summary => "Just testing", :content => "Blah blah"}
    assert_response :success
    assert_select 'h2', "Just testing"
  end
  
  def test_create
    get :new, :project => @project.short_name
    submit_form do |form|
      form['ticket[part_id]'] = "1"
      form['ticket[author]'] = "bob"
      form['ticket[summary]'] = "testing create"
      form['ticket[content]'] = "this is a ticket" 
      form['ticket[severity_id]'] = "1"
      form['ticket[milestone_id]'] = "1"
    end
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => Ticket.find(:first, :conditions => ["summary = ?","testing create"]).id
  end
  
  def test_invalid_create
    get :new, :project => @project.short_name
    submit_form do |form|
      form['ticket[part_id]'] = "1"
      form['ticket[author]'] = "bob"
      form['ticket[content]'] = "this is a ticket" 
      form['ticket[severity_id]'] = "1"
      form['ticket[milestone_id]'] = "1"
    end
    assert_response :success
    assert assigns(:ticket).errors.on('summary')
  end

  def test_need_post_for_delete_change
    get :delete_change, :project => @project.short_name, :id => 1
    assert_response 400
    assert_equal "bad request: only post allowed", @response.body
  end

  def test_need_to_be_admin_for_delete_change
    post :delete_change, :project => @project.short_name, :id => 1
    assert_response 400
    assert_equal "Access Denied", @response.body
  end

  def test_delete_change
    assert TicketChange.find_by_id(1)
    @request.env["HTTP_REFERER"] = "/foo/bar" # set referer so redirect_to :back works
    @request.session[:user] = users("bob").id # log in as admin user
    post :delete_change, :project => @project.short_name, :id => 1
    assert_response :redirect
    assert_redirected_to "/foo/bar"
    assert_nil TicketChange.find_by_id(1)
  end

  def test_show_ticket_shows_delete_change_link_to_admins
    @request.session[:user] = users("bob").id # log in as admin user
    get :show, :id => 1, :project => @project.short_name
    assert_response :success
    assert_select %Q{a[href*="delete_change"]}
  end

  def test_show_ticket_does_not_show_delete_change_link_to_non_admins
    get :show, :id => 1, :project => @project.short_name
    assert_response :success
    assert_select %Q{a[href*="delete_change"]}, false
  end

  def test_need_post_for_destroy
    get :destroy, :project => @project.short_name, :id => 1
    assert_response 400
    assert_equal "bad request: only post allowed", @response.body
  end

  def test_need_to_be_admin_for_destroy
    post :destroy, :project => @project.short_name, :id => 1
    assert_response 400
    assert_equal "Access Denied", @response.body
  end

  def test_destroy
    assert Ticket.find_by_id(1)
    @request.session[:user] = users("bob").id # log in as admin user
    post :destroy, :project => @project.short_name, :id => 1
    assert_response :redirect
    assert_redirected_to :action => "index", :project => @project.short_name
    assert_nil Ticket.find_by_id(1)
  end

  def test_show_ticket_shows_destroy_link_to_admins
    @ticket = tickets(:open_ticket)
    @request.session[:user] = users("bob").id # log in as admin user
    get :show, :id => @ticket.id, :project => @project.short_name
    assert_response :success
    assert_select %Q{a[href*="destroy"]}
  end

  def test_show_ticket_does_not_show_destroy_link_to_non_admins
    get :show, :id => 1, :project => @project.short_name
    assert_response :success
    assert_select %Q{a[href*="destroy"]}, false
  end

end
