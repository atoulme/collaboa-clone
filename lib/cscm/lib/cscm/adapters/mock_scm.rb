require 'ostruct'
require "pathname"
require "stringio"

module Cscm
  module Adapters
    module MockScm
      class MockNode      
        def initialize(path, revision)
          path = path.chomp("/")
          @path = Pathname.new("/#{path}").cleanpath.to_s
          @revision = revision || 5
        end
        attr_reader :path, :revision
        
        def entries
          dirs = (1..5).map{|r| self.class.new("/moo#{r}/", r)}
          dirs << self.class.new("/moo1/README", 5)
          dirs << self.class.new("/moo1/stuff/haiku.rb", 4)
          dirs << self.class.new("/file.txt", 5)
          dirs.reverse
        end
      
        def dir?
          @path.empty? || !(@path.length > 1) || @path[-1] == ?/
        end        
        
        def file?
          !dir?
        end
        
        def name
          File.basename(@path)
        end
        
        def log
          "commit of #{@path} @ #{@revision}"
        end
        
        def author
          "johan"
        end
        
        def size
          dir? ? 0 : 42
        end
        
        def mtime
          Time.now
        end
        alias_method :date, :mtime
        
        def proplist
          {}
        end
        
        def contents(&blk)
          return if dir?
          StringIO.new("abc"*300)
        end      
      end
    
      class Base      
        def initialize(repository_path, options={})
          @repository_path = repository_path
          @options = options
        end
        attr_reader :repository_path
      
        def get_node(path, revision)
          MockNode.new(path, revision)
        end
      
        def get_changeset(revision)
          props = {
            :author       => "author@#{revision}",
            :log          => "log msg for #{revision}",
            :date         => Time.now,
          
            :deleted_nodes  => ["foo.txt", "/somedir"],
            :copied_nodes   => ["foo.txt", "/somedir"],
            :added_nodes    => ["foo.txt", "/somedir"],
            :updated_nodes => ["foo.txt", "/somedir"],
            :moved_nodes => ["foo.txt", "/somedir"],
          }
          OpenStruct.new(props)
        end
      
        def youngest_revision
          42
        end
      
        def udiff_with_revision(path, revision)
        
        end      
      end
    end
  end
end