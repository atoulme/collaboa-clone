require File.dirname(__FILE__) + '/../test_helper'

if Collaboa::CONFIG.subversion_support

class ChangesetTest < Test::Unit::TestCase
  fixtures :changesets, :changes, :repositories, :projects

  def setup
    @changeset1 = Changeset.find(1)
  end
  
  def test_sync_changesets
    assert_equal 1, Repository.find(:all).size
    assert Changeset.sync_changesets  # run sync_changesets and make sure it goes ok
    
    assert_equal "importing test data", @changeset1.log
    
    changeset_2 = Changeset.find_by_revision(2)
    assert_equal "edited file1.txt", changeset_2.log
    assert_equal 2, changeset_2.revision
    assert_equal "johan", changeset_2.author
    
    changeset_3 = Changeset.find_by_revision(3)
    assert_equal "edited file1.txt again", changeset_3.log
    assert_equal 3, changeset_3.revision
    assert_equal "johan", changeset_3.author
    assert_equal "file1.txt", changeset_3.changes.first.path
    assert_equal "M", changeset_3.changes.first.name
  end
  
  def test_search
    Changeset.sync_changesets
    
    q = Changeset.search("importing", projects(:first_project))
    assert_equal 1, q.size
    
    q = Changeset.search("importing", projects(:fourth_project))
    assert_equal 0, q.size
    
    q = Changeset.search("importing")
    assert_equal 1, q.size
  end

  def test_find_all_by_project
    Changeset.sync_changesets
    changesets = Changeset.find_all_by_project(projects(:fourth_project))
    assert_equal 1, changesets.size
    assert_equal 12, changesets.first.revision
  end
end
end
