require File.dirname(__FILE__) + '/../test_helper'

class TicketChangeTest < Test::Unit::TestCase
  fixtures :ticket_changes

  def setup
    @ticket_change = TicketChange.find(1)
  end
  
  def test_search
    q = TicketChange.search("a comment", Project.find(1))
    assert_equal 1, q.size

    q = TicketChange.search("a comment", Project.find(2))
    assert_equal 0, q.size
    
    q = TicketChange.search("a comment")
    assert_equal 1, q.size
  end

  def test_each_log
    change = TicketChange.new do |c|
      c.log = {'Status' => %w{Open Fixed}, 'Part' => %w{Part1 Part2}, 'Content' => ["old comment","new comment"]}
    end
    result = []
    change.each_log{|c| result << c}
    assert_equal "Status", result[0].attribute
    assert_equal "Open", result[0].old_value
    assert_equal "Fixed", result[0].new_value

    assert_equal "Part", result[1].attribute
    assert_equal "Part1", result[1].old_value
    assert_equal "Part2", result[1].new_value

    assert_equal "<strong>Status</strong> changed from <em>Open</em> to <em>Fixed</em>", result[0].format_changes
    assert_equal "<strong>Part</strong> changed from <em>Part1</em> to <em>Part2</em>", result[1].format_changes
    assert_equal "<li><strong>Content</strong> changed:</li><div class=\"ticketdiff\">\n  <del>\n    <p>old comment</p>\n  </del>\n  <ins>\n    <p>new comment</p>\n  </ins>\n</div>", result[2].format_changes
    assert_equal "Status changed from <em>Open</em> to <em>Fixed</em> Part changed from <em>Part1</em> to <em>Part2</em> <strike>\n    old comment\n  </strike> \n    new comment\n  ", change.format_changes_one_line
  end
  
  def test_empty_comment
    change = TicketChange.new do |c|
      c.comment = 'a comment'
    end
    assert !change.empty?
    change.comment = nil
    assert change.empty?
  end

  def test_empty_log
    change = TicketChange.new do |c|
      c.log = {'Part' => %w{Part1 Part2}}
    end
    assert !change.empty?
    change.log = {}
    assert change.empty?
  end

  def test_empty_attachment
    change = TicketChange.new do |c|
      c.attachment = 'file.txt'
    end
    assert !change.empty?
    change.attachment = nil
    assert change.empty?
  end
end
