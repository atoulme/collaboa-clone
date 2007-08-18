require File.dirname(__FILE__) + '/../test_helper'

class Cscm::Adapters::SubversionTest < Test::Unit::TestCase  
  
  # [johan@steakhouse]$ svnlook tree test/adapters/fixtures/subversion/
  # /
  #  new_dir-copy/
  #  random-bins.bin
  #  new_dir-copy2/
  #  somefile.txt
  #  new_dir-copy3/
  #  ruby.rb
  #  html/
  #   html_file.html
  #  file1-copy.txt
  #  html_file.html
  #  new_dir/
  #  moved_dir/
  #  xaa
  #  project4/
  #   trunk/
  #    project4.rb
  #   README
  #  ruby-copy.rb
  #  file.txt
  
  def setup
    setup_repos
    @repository = Cscm::Repository.new(test_repos_path, :subversion)
  end
  
  def teardown
    teardown_repos
  end
  
  def test_get_node
    node = @repository.node("/", 12)
    assert_instance_of Cscm::Adapters::Subversion::Node, node
    assert_not_nil node.root
    # test we can find previous revision
    assert_nothing_raised {
      node = @repository.node("file1.txt", 3)
    }
  end
  
  def test_get_node_directories
    node = @repository.node("/", 12)
    dirs = %w[/new_dir-copy /new_dir-copy2 /new_dir-copy3 /html /new_dir /moved_dir /project4]
    assert_equal dirs.sort, node.directories.map{|d| d.path}.sort
    assert node.respond_to?(:dirs)
  end
  
  def test_get_node_files
    node = @repository.node("/", 12)
    files = %w[/random-bins.bin /somefile.txt /ruby.rb /file1-copy.txt /html_file.html
                /xaa /ruby-copy.rb /file.txt]
    assert_equal files.sort, node.files.map{|f| f.path}.sort
  end
  
  def test_get_node_entries
    node = @repository.node("file.txt")
    assert_nil node.entries
    
    node = @repository.node("/", 12)
    assert_not_nil node.entries
    assert_instance_of Array, node.entries
    assert_instance_of Cscm::Adapters::Subversion::Node, node.entries.first
    assert_equal 15, node.entries.size
    entries = [ "/somefile.txt", "/html", "/ruby-copy.rb", "/new_dir-copy2", 
                "/moved_dir", "/file.txt", "/new_dir-copy3", "/xaa",
                "/random-bins.bin", "/project4", "/new_dir", "/ruby.rb",
                "/file1-copy.txt", "/new_dir-copy", "/html_file.html" ]
    assert_equal entries, node.entries.map{|e| e.path}
  end
  
  def test_get_node_revision
    assert_equal 11, @repository.node("file.txt").revision
    assert_equal 12, @repository.node("/", 12).revision
    assert_equal @repository.youngest_revision, @repository.node("/").revision
    assert_equal 3, @repository.node("file1.txt", 3).revision
    assert_equal 2, @repository.node("file1.txt", 2).revision
  end
  
  def test_get_node_dir?
    assert @repository.node("project4/").dir?
    assert !@repository.node("file.txt").dir?
  end
  
  def test_get_node_file?
    assert !@repository.node("project4/").file?
    assert @repository.node("file.txt").file?
  end
  
  def test_get_node_name
    assert_equal "file.txt", @repository.node("file.txt").name
    assert_equal "html_file.html", @repository.node("/html/html_file.html").name
    assert_equal "project4/", @repository.node("project4").name
    assert_equal "project4/", @repository.node("project4/").name
    assert_equal "trunk/", @repository.node("project4/trunk").name
  end
  
  def test_get_node_author
    assert_equal "johan", @repository.node("/html/").author
    assert_equal "", @repository.node("file.txt").author
    assert_equal "jasongarber", @repository.node("project4/").author
  end
  
  def test_get_node_mtime
    assert_instance_of Time, @repository.node("file.txt").mtime
    assert_equal "Tue Jul 05 17:27:17 +0200 2005", @repository.node("file.txt").mtime.to_s
  end
  
  def test_get_node_log
    assert_equal "deleted a file + moved a file + copied a file\n", @repository.node("file.txt").log
    assert_equal "Projects-as-subdirectories in one repository.\n", @repository.node("project4/").log
  end
  
  def test_get_node_size
    assert_equal 26, @repository.node("file.txt").size
    assert_equal 0, @repository.node("/project4/").size
  end
  
  def test_get_node_proplist
    exp = {}
    assert_equal exp, @repository.node("file.txt").proplist
    mime_exp = {"svn:mime-type"=>"application/octet-stream"}
    assert_equal mime_exp, @repository.node("random-bins.bin").proplist
  end
  
  def test_get_node_contents
    node= @repository.node("html_file.html")
    assert node.contents.respond_to?(:read)
    exp = "<html>\n\t<head>\n\t\t<title>html test doc</title>\n\t</head>\n<body>\n\t<h1>Header!</h1>\n</body>\n</html>\n"
    assert_equal exp, node.contents.read
    node.contents do |f|
      assert_equal exp, f.read
    end
  end
  
  def test_get_node_udiff
    node = @repository.node("file1.txt", 3)
    exp = "--- Revision 2\n+++ Revision 3\n@@ -1 +1 @@\n-not any more\n+I am the silly test file!\n"
    assert_equal exp, node.udiff_with_revision(2)
  end
  
  def test_get_node_equals
    assert @repository.node("file.txt") == @repository.node("file.txt")
    assert !(@repository.node("file.txt") == @repository.node("/"))
    assert !(@repository.node("/") === Array.new)
  end
  
  def test_get_node_inspect
    assert_equal "<Cscm::Adapters::Subversion::Node:/@12>", @repository.node("/", 12).inspect
    assert_equal "<Cscm::Adapters::Subversion::Node:/file1.txt@3>", @repository.node("file1.txt", 3).inspect
  end
  
  def test_get_node_to_s
    assert_equal "/", @repository.node("/", 12).to_s
    assert_equal "/file.txt", @repository.node("file.txt", 12).to_s
    assert_equal "/file.txt", @repository.node("/file.txt", 12).to_s
  end
  
  def test_get_changeset
    changeset = @repository.changeset(1)
    assert_instance_of Cscm::Adapters::Subversion::Changeset, changeset
    assert_equal "johan", changeset.author
    assert_equal "importing test data", changeset.log
    assert_instance_of Time, changeset.date
    assert_equal "Sat May 28 22:58:00 +0200 2005", changeset.date.to_s
  end
  
  def test_get_changeset_added_files
    changeset = @repository.changeset(1)
    added = %w[file1.txt html/ html/html_file.html html_file.html 
              ruby.rb urandom.bin xaa]
    assert_equal added.sort, changeset.added_nodes.sort
  end
  
  def test_get_changeset_updated_files
    changeset = @repository.changeset(2)
    updated = %w[file1.txt]
    assert_equal updated.sort, changeset.updated_nodes.sort
  end
  
  def test_get_changeset_deleted_files
    changeset = @repository.changeset(11)
    deleted = %w[file1copy.txt]
    assert_equal deleted.sort, changeset.deleted_nodes.sort
  end
  
  def test_get_changeset_detects_moved_node_proper
    changeset = @repository.changeset(9)
    moved = [["moved_dir/", "new_dir-copy4/", 8], ["random-bins.bin", "urandom.bin", 4]]
    assert_equal moved.sort, changeset.moved_nodes.sort
    
    changeset = @repository.changeset(11)
    moved = [["file1-copy.txt", "file1.txt", 4]]
    assert_equal moved.sort, changeset.moved_nodes.sort
  end
  
  def test_get_changeset_copied_nodes
    changeset = @repository.changeset(10)
    copied = [["somefile.txt", "file1.txt", 4]]
    assert_equal copied.sort, changeset.copied_nodes.sort
  end
  
  def test_youngest_revision
    assert_equal 12, @repository.youngest_revision
  end
  
  def test_udiff_with_revision
    diff = @repository.udiff('file1.txt', 3)
    expected_diff = "--- Revision 2\n+++ Revision 3\n@@ -1 +1 @@\n-not any more\n+I am the silly test file!\n"
    assert_equal expected_diff, diff
  end
  
  def test_node_to_xml
    node = @repository.node("/html/")
    expected_xml = <<EOS
<repository-node>
  <name>html/</name>
  <revision>1</revision>
  <size>0</size>
  <date>Sat May 28 22:58:00 +0200 2005</date>
  <author>johan</author>
  <entries>
    <entry>
      <name>html_file.html</name>
      <revision>1</revision>
      <size>96</size>
      <date>Sat May 28 22:58:00 +0200 2005</date>
      <author>johan</author>
    </entry>
  </entries>
</repository-node>
EOS
  assert_equal expected_xml, node.to_xml
  end
  
  def test_node_to_xml_doesnt_create_empty_entry_elements_for_empty_dirs
    node = @repository.node("/new_dir/")
    expected_xml = <<EOS
<repository-node>
  <name>new_dir/</name>
  <revision>4</revision>
  <size>0</size>
  <date>Tue Jun 21 11:07:06 +0200 2005</date>
  <author></author>
  <entries>
  </entries>
</repository-node>
EOS
    assert_equal expected_xml, node.to_xml
  end
  
  private
    def test_repos_path
      File.join(File.dirname(__FILE__) + "/../tmp/subversion")
    end
    
    def setup_repos
      @full_repos_path = File.expand_path(test_repos_path)
      FileUtils.mkdir(File.dirname(__FILE__) + "/../tmp/")
      FileUtils.cp_r(File.dirname(__FILE__) + "/fixtures/subversion", File.dirname(__FILE__) + "/../tmp/")
      @repos = Svn::Repos.open(test_repos_path)
      @fs = @repos.fs
    end

    def teardown_repos
      # Svn::Repos.delete(path)
      FileUtils.rm_rf(File.dirname(__FILE__) + "/../tmp/")
    end
end