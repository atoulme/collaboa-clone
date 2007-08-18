require 'svn/core'
require 'svn/fs'
require 'svn/delta'
require 'svn/repos'
require 'svn/client'

require 'builder'

module Cscm
  module Adapters
    module Subversion
      # Represents a node within the repository.
      # If the Node is a directory the entries method will yield an array of Node's
      # of all the nodes within itself
      class Node
        # +path+ that this node is located within the f+s+ (a Svn::Fs instance) 
        # at +revision+
        def initialize(path, fs, revision=nil)
          @fs = fs
          @path = sanitize_path(path)
          @rev = revision || @fs.youngest_rev
          @root = @fs.root(@rev)
        end
        attr_accessor :root, :path, :fs
        
        # Returns an array of the directories within this node
        def directories
          entries.select{|e| e.dir?}
        end
        alias_method :dirs, :directories
        
        # Returns an array of Node's composed of the files within this path
        def files
          entries.select{|e| e.file? }
        end
        
        # returns an array of Subversion::Node's if the current @path is a directory
        # otherwise it returns nil
        def entries
          node_type = @root.check_path(@path)
          if node_type == Svn::Core::NODE_DIR
            dir_entries = @root.dir_entries(@path).keys        
            entries = dir_entries.map do |entry|
              fullpath = File.join(path, entry)
              self.class.new(fullpath, @fs, @rev)
            end
          else # this isn't a directory
            entries = nil
          end
          entries
        end
        
        # Returns the current revision of this Node
        def revision
          @root.node_created_rev(@path)
        end
        
        # True if this Node is a dir
        def dir?
          @root.dir?(@path)
        end
        
        # True if this Node is a file
        def file?
          !dir?
        end
        
        # Returns the basename of the Node, if it's a directory it'll end with "/"
        def name
          if dir?
            base = @path.chomp("/")
            File.basename(@path) + "/"
          else
            return File.basename(@path)
          end
        end
        
        # Returns the author of this Node as of the revision passed in the Node#new
        def author
          @fs.prop(Svn::Core::PROP_REVISION_AUTHOR, revision).to_s
        end
        
        # Returns the mtime of the Node
        def mtime
          @fs.prop(Svn::Core::PROP_REVISION_DATE, revision)
        end
        alias_method :date, :mtime
        
        # The log message associated with the commit of this Node at its given
        # revision
        def log
          @fs.prop(Svn::Core::PROP_REVISION_LOG, revision) || ''
        end
        
        # The size of the Node, if it's a file, will always be 0 if it's a dir
        def size
          if file?
            @root.file_length(@path).to_i
          else
            0
          end
        end
        
        # The props for this Node
        def proplist
          @root.node_proplist(@path)
        end
        
        # Returns a File-like objects of the Node (if it's a file), that either
        # takes a block or not, responds to #read
        def contents(&blk)
          return if dir?
          @root.file_contents(@path, &blk)
        end
        
        # Gets the mime type of a node.
        # TODO: Fix the implementation
        def mime_type
          return '' if self.dir?
          mime = @root.node_prop(@path, Svn::Core::PROP_MIME_TYPE) || ''
          mime
        end
        
        def udiff_with_revision(rev)
          old_root = @fs.root(rev)
          differ = Svn::Fs::FileDiff.new(old_root, @path, @root, @path)
          return nil if differ.binary?
          old = "Revision #{old_root.node_created_rev(path)}"
          cur = "Revision #{@root.node_created_rev(path)}"
          udiff = differ.unified(old, cur)      
        end
        
        def ==(other)
          return false unless self.class === other
          @path.to_s == other.path.to_s
        end
        alias_method :===, :==
        alias_method :eql?, :==
        
        def inspect
          "<#{self.class}:#{@path}@#{revision}>"
        end
        
        def to_s
          @path.to_s
        end
        
        SERIALIZABLE_ATTRIBUTES = [:name, :revision, :size, :date, :author]
        
        # Serializes the Node into XML according to SERIALIZABLE_ATTRIBUTES
        def to_xml
          builder = Builder::XmlMarkup.new(:indent => 2)
          builder.tag!("repository-node") do |rn|
            SERIALIZABLE_ATTRIBUTES.each do |meth|
              rn.tag!(meth.to_s, __send__(meth))
            end            
            rn.tag!("entries") do |ee|
              entries.each do |entry|
                ee.tag!("entry") do |e|
                  SERIALIZABLE_ATTRIBUTES.each do |meth|
                    e.tag!(meth.to_s, entry.__send__(meth))
                  end
                end
              end
            end
          end
        end
        
        private
          def sanitize_path(path)
            path = path.chomp('/')
            path = "/#{path}" unless path[0] == ?/
            path
          end
      end
      
      class Changeset
        # A new instannce of a changeset within +fs+ at +revision+
        def initialize(fs, revision)
          @revision = revision
          @fs = fs
          @editor = editor_for_revision(@revision)
          
          @added_files    = @editor.added_files
          @added_dirs     = @editor.added_dirs
          @updated_files  = @editor.updated_files
          @updated_dirs   = @editor.updated_dirs
          @deleted_files  = @editor.deleted_files
          @deleted_dirs   = @editor.deleted_dirs
          @copied_files   = @editor.copied_files
          @copied_dirs    = @editor.copied_dirs
          
          @added_nodes    = @added_dirs + @added_files
          @updated_nodes  = @updated_dirs + @updated_files
          @deleted_nodes  = @deleted_dirs + @deleted_files
          @copied_nodes   = @copied_dirs + @copied_files
          @moved_nodes    = delta_moved_nodes_from_deleted_nodes
          @copied_nodes   = @copied_nodes - @moved_nodes
        end
        attr_accessor :revision, :fs
        attr_reader :added_nodes, :updated_nodes
        attr_reader :copied_nodes, :moved_nodes
        attr_reader :deleted_nodes
        
        # The author of this changeset (the committer/commitee/commitaurius)
        def author
          @fs.prop(Svn::Core::PROP_REVISION_AUTHOR, @revision).to_s
        end
        
        # The log entry associated with this changeset
        def log
          @fs.prop(Svn::Core::PROP_REVISION_LOG, @revision)
        end
        
        # The date this changeset was committed
        def date
          @fs.prop(Svn::Core::PROP_REVISION_DATE, @revision)
        end
        
        protected
          # Calculates the moved nodes based on the copied nodes if it also
          # exists in the deleted nodes array
          def delta_moved_nodes_from_deleted_nodes
            @copied_nodes.inject([]) do |moved, copied_node|
              moved << copied_node if @deleted_nodes.delete(copied_node[1])
              moved    
            end
          end
          
          # returns an Svn::Delta::ChangedEditor for this revision
          def editor_for_revision(rev)
            root = @fs.root(rev)
            base_rev = rev - 1
            base_root = @fs.root(base_rev)
            editor = Svn::Delta::ChangedEditor.new(root, base_root)
            base_root.dir_delta("", "", root, "", editor)
            editor
          end
      end
      
      class Base 
        def initialize(repository_path, options={})
          @repository_path = sanitize_repos_path(repository_path)
          @repos = Svn::Repos.open(@repository_path)
          @fs = @repos.fs
          @options = options
        end
        attr_accessor :repository_path, :repos, :fs
      
        def get_node(path, revision)
          Node.new(path, @fs, revision)
        end
      
        def get_changeset(revision)
          Changeset.new(@fs, revision)
        end
      
        # Returns the youngest revision for the repository
        def youngest_revision
          @fs.youngest_rev
        end
      
        def udiff_with_revision(path, revision)
          Node.new(path, @fs, revision).udiff_with_revision(revision-1)
        end   
        
        private
          def sanitize_repos_path(path)
            path.chomp('/')
          end   
      end      
    end
  end
end