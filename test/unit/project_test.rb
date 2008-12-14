require File.dirname(__FILE__) + '/../test_helper'

class ProjectTest < Test::Unit::TestCase
  fixtures :projects, :status, :severities, :parts,
    :tickets, :ticket_changes, :milestones, :releases, :users

  def setup
    @project = Project.find(1)
  end
  
  def test_adds_public_user_before_create
    project = Project.create
    assert_equal 1, project.users.size
    assert_equal 'Public', project.users.first.login
  end

  def test_project_has_many_tickets
    assert @project.tickets.include?(tickets(:open_ticket))
    assert @project.tickets.include?(tickets(:ticket3))
    assert !@project.tickets.include?(tickets(:ticket_for_second_project))
  end

  def test_project_has_many_milestones
    assert @project.milestones.include?(milestones(:milestone1))
    assert @project.milestones.include?(milestones(:milestone2))
    assert !@project.milestones.include?(milestones(:milestone_for_second_project))
  end
  
  def test_project_has_many_releases
    assert @project.releases.include?(releases(:first_release))
    assert @project.releases.include?(releases(:another_release))
    assert !@project.releases.include?(releases(:release_for_second_project))
  end
  
  def test_project_has_many_parts
    assert @project.parts.include?(parts(:part1))
    assert @project.parts.include?(parts(:part2))
    assert !@project.parts.include?(parts(:part_for_second_project))
  end

  def test_admins_get_all_projects
    u = User.new    
    u.login = "admin"
    u.password = u.password_confirmation = "adminpass"
    u.admin = true
    u.save
    
    @project.users << u
    projects(:closed).users << u
    assert_equal 4, Project.show_for_user(u).length
  end

  def test_non_admin_gets_only_correct_projects
    u = User.new    
    u.login = "nonadmin"
    u.password = u.password_confirmation = "nonadminpass"
    u.admin = false
    u.save
    
    @project.users << u
    projects(:closed).users << u
    assert_equal 1, Project.show_for_user(u).length
  end

  def test_get_changes_for_project_ordered_by_date
    ticket = Ticket.new do |t|
      t.summary = "summary"
      t.content = "content"
      t.author = "tom"
      t.project = @project
    end

    change1 = TicketChange.new do |c|
      c.ticket = ticket
      c.comment = "a"
      c.log = {'Status' => %w{Open Fixed}, 'Part' => %w{Part1 Part2}}
      c.author = "author"
      c.created_at = Date.new(2005,9,1)
      c.save
    end

    change2 = TicketChange.new do |c|
      c.ticket = ticket
      c.comment = "b"
      c.log = {'Status' => %w{Open Fixed}, 'Part' => %w{Part1 Part2}}
      c.author = "author"
      c.created_at = Date.new(2005,10,1)
      c.save
    end

    assert_equal "Created", @project.changes[0][:comment]
    assert_equal "b", @project.changes[1][:comment]
    assert_equal "a", @project.changes[2][:comment]
    assert_equal "a comment", @project.changes[3][:comment]
  end
  
  def test_absolutize_svn_path
    project = Project.find(4)    
    assert_equal 'project4/README', project.absolutize_svn_path('README')
    assert_equal 'project4/trunk/project4.rb', project.absolutize_svn_path('trunk/project4.rb')
  end
  
  def test_relativize_svn_path
    project = Project.find(4)    
    assert_equal 'README', project.relativize_svn_path('project4/README')
    assert_equal 'trunk/project4.rb', project.relativize_svn_path('project4/trunk/project4.rb')
  end
  
  def test_relativize_and_absolutize_have_no_effect_when_root_path_blank
    assert_equal 'ruby.rb', @project.relativize_svn_path('ruby.rb')
    assert_equal 'ruby.rb', @project.absolutize_svn_path('ruby.rb')
    assert_equal 'html/html_file.html', @project.absolutize_svn_path('html/html_file.html')
    assert_equal 'html/html_file.html', @project.relativize_svn_path('html/html_file.html')
  end
  
  def test_root_path_properly_formatted
    project = Project.new(:root_path => ' /something/like/this ')
    assert project.save
    assert_equal 'something/like/this/', project.reload.root_path
  end

  def excludes_other_projects
    ticket = Ticket.new do |t|
      t.summary = "summary"
      t.content = "content"
      t.author = "tom"
      t.project = Project.find(2)
    end

    change1 = TicketChange.new do |c|
      c.ticket = ticket
      c.comment = "a"
      c.log = {'Status' => %w{Open Fixed}, 'Part' => %w{Part1 Part2}}
      c.author = "author"
      c.created_at = Date.new(2005,9,1)
      c.save
    end
    
    assert_equal [], @project.changes
  end
end
