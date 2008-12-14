require File.dirname(__FILE__) + '/../test_helper'

if Collaboa::CONFIG.subversion_support

class RepositoryTest < Test::Unit::TestCase
  fixtures :repositories, :projects
  
  def setup
    @repos = repositories(:test)
    @project = projects :first_project
  end

  def test_pass_through_to_svn
    # make sure dynamic finders work as expected
    assert_nothing_raised {
      assert_equal @project, Project.find_by_name("first project")
      assert_equal repositories(:test), Repository.find_by_name("testing repos")
    }    
    assert_equal "testing repos", @repos.name_before_type_cast
    assert_equal "first project", @project.name_before_type_cast
    
    # svn stuff
    assert_equal 12, @repos.fs.get_youngest_rev
    assert @repos.fs.is_dir?('/html')
    
    # misc
    assert_not_nil @repos.path
    assert_equal "testing repos", @repos.name
    assert Repository.create(:name => 'foo', :path => '/path/to/foo')
    assert Repository.new(:name => 'foo', :path => '/path/to/foo')
  end
  
end
end
