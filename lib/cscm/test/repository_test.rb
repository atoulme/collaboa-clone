require File.dirname(__FILE__) + '/test_helper'

class RepositoryTest < Test::Unit::TestCase
  
  def setup
    @repository = Cscm::Repository.new("/tmp", :mock)
  end
  
  def test_default_adapters_are_available
    assert Cscm::Repository.scm_adapters.keys.include?(:mock)
    assert Cscm::Repository.scm_adapters.keys.include?(:subversion)
    assert_equal Cscm::Adapters::MockScm::Base, Cscm::Repository.scm_adapters[:mock]
    assert_equal Cscm::Adapters::Subversion::Base, Cscm::Repository.scm_adapters[:subversion]
  end
  
  # def test_new_should_set_default_adapter
  #   repository = Cscm::Repository.new("/tmp")
  #   assert_not_nil repository.adapter
  #   assert_instance_of Cscm::Adapters::Subversion::Base, repository.adapter
  #   assert_equal "/tmp", repository.repository_path
  # end
  
  def test_node
    node = @repository.node("/")
    assert node
    assert_equal Cscm::Adapters::MockScm::MockNode, node.class
    assert node.respond_to?(:entries)
    assert node.respond_to?(:revision)
    
    node_rev = @repository.node("/", 12)
    assert_equal 12, node_rev.revision
  end
  
  def test_nodes
    nodes = @repository.nodes("/")
    assert_instance_of Array, nodes
    assert_instance_of Cscm::Adapters::MockScm::MockNode, nodes.first
    
  end
  
  def test_changeset
    chg = @repository.changeset(10)
    [ :author, :log, :date, :deleted_nodes, :copied_nodes, :added_nodes, 
    :updated_nodes, :moved_nodes ].each do |prop|
      assert chg.respond_to?(prop)
    end
  end
  
  def test_youngest_revision
    assert_equal 42, @repository.youngest_revision
  end
  
  def test_udiff
    assert @repository.respond_to?(:udiff)
  end
  
end