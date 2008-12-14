require File.dirname(__FILE__) + '/../test_helper'

class TicketTest < Test::Unit::TestCase
  fixtures :tickets, :parts, :milestones, :severities, :status
  fixtures :releases, :ticket_changes#, :attachments           

  def setup
    @ticket = Ticket.find(1)
    @ticket2 = Ticket.find(2)
  end
  
  def test_search
    q = Ticket.search(tickets(:open_ticket).summary, Project.find(1))
    assert_equal 1, q.size

    q = Ticket.search(tickets(:open_ticket).summary, Project.find(2))
    assert_equal 0, q.size
    
    q = Ticket.search(tickets(:open_ticket).summary)
    assert_equal 1, q.size
  end
  
  def test_find_by_filter
    params = {"status"=>"1", "action"=>"index", "controller"=>"tickets"}
    tickets = Ticket.find_by_filter(params)
    assert_equal Ticket.find_all_by_status_id(1).size, tickets.size
  end
  
  def test_find_by_filter2
    # Will find all tickets
    params = {"stat';us"=>"1", "action"=>"index", "controller"=>"tickets"}
    tickets = Ticket.find_by_filter(params)
    assert_equal Ticket.count, tickets.size
  end
  
  def test_find_by_filter3
    params = {"milestone"=>"1", "action"=>"index", "controller"=>"tickets"}
    tickets = Ticket.find_by_filter(params)
    assert_equal 0, tickets.size
  end
  
  def test_find_by_filter_with_array_params
    # If you wanted to find open and fixed tickets (but not invalid)
    params = {"status"=> %w(1 2), "action"=>"index", "controller"=>"tickets"}
    tickets = Ticket.find_by_filter(params)
    open_tickets = Ticket.find_all_by_status_id(1).size
    fixed_tickets = Ticket.find_all_by_status_id(2).size
    assert fixed_tickets > 0
    assert_equal open_tickets + fixed_tickets, tickets.size
  end

  def test_edit
    params =  {:ticket => {:part_id => 2, 
                    :release_id => 2, 
                    :summary => "edited summary", 
                    :content => "other content", 
                    :severity_id => 1, 
                    :status_id => 1, 
                    :milestone_id => 1},
                    :change => {:attachment => "", 
                                :author => "bob", 
                                :comment => ""}
                    }
    
    assert @ticket.save(params)
    change = @ticket.ticket_changes.last

    assert_equal 2, @ticket.ticket_changes.size
    assert_equal 'edited summary', @ticket.summary
    assert_equal 2, @ticket.part_id
    assert_equal 2, @ticket.release_id
    assert_not_nil change.log
    assert_equal 5, change.log.size
    assert_equal ["first test ticket", "edited summary"], change.log['Summary']
    assert_equal ["Unspecified", "0.2"], change.log['Release']
    assert_equal ["Component 1", "Component 2"], change.log[FIELD_NAME['Part']]
    assert_equal ["Just testing", "other content"], change.log['Content']
  end
  
  def test_edit_with_no_changes
    params =  {:ticket => {:part_id => 2, 
                    :release_id => 2, 
                    :summary => "second test ticket", 
                    :severity_id => 2, 
                    :status_id => 2, 
                    :milestone_id => 2},
                :change => {:attachment => "", 
                            :author => "bob", 
                            :comment => ""}
              }

    assert !@ticket2.save(params)
    assert_equal "No changes has been made", @ticket2.errors['base']
  end
  
  def test_create
    ticket = Ticket.new(:author => 'bob',
                        :part_id => 2, 
                        :release_id => 2, 
                        :summary => "new ticket summary", 
                        :severity_id => 1, 
                        :status_id => 1, 
                        :milestone_id => 1,
                        :content => 'some random description',
                        :author_host => '127.0.0.1',
                        :project => Project.find(1))
    ticket.save

    assert_equal 1, ticket.ticket_changes.size
    assert_equal 'Created', ticket.ticket_changes[0].comment
    assert ticket
  end
  
  def test_validations
    @ticket.author = nil
    assert !@ticket.valid?
    
    @ticket.author = 'foo'
    @ticket.summary = nil
    assert !@ticket.valid?
    
    @ticket.author = 'foo'
    @ticket.summary = 'bar'
    @ticket.content = nil
    assert !@ticket.valid?
  end

  def test_get_child_tickets
    ticket = Ticket.find(4)
    assert_equal 1, ticket.child_tickets.count
  end

  def test_get_parent_tickets
    ticket = Ticket.find(5)
    assert_equal 4, ticket.parent.id
  end
end
