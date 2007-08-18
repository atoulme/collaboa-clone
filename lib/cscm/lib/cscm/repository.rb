module Cscm
  class Repository
    # Available SCM adapters
    @@scm_adapters = {
      :mock => Cscm::Adapters::MockScm::Base,
      :subversion => Cscm::Adapters::Subversion::Base,
    }
    cattr_accessor :scm_adapters
    
    # New Repository object where the actual repository filesystem is located
    # at +repository_path+. +adapter+ is the SCM adapter we wish to use, defaults
    # to Cscm::Adapters::Subversion is +adapter+ is nil.
    def initialize(repository_path, adapter=:subversion, adapter_options={})
      @repository_path = repository_path
      @adapter = Cscm::Repository.scm_adapters[adapter].new(@repository_path, adapter_options)
    end
    attr_accessor :repository_path, :adapter
    
    # Returns a node for the given adapter located at +path+ at +revision+, 
    # if no +revision+ is given, the youngest is used
    # raises InvalidPath or InvalidRevision if the +path+ or +revision+ is invalid
    def node(path, revision=nil)
      @adapter.get_node(path, revision)
    end
    
    # Returns an array of nodes for the given +path+ and +revision+ (youngest 
    # if no +revision+) was given. May return nil if the +path+ is a file
    def nodes(path, revision=nil)
      @adapter.get_node(path, revision).entries
    end
    
    # Return a specific changeset at +revision+ for the current adapter
    def changeset(revision)
      @adapter.get_changeset(revision)
    end
    
    # Returns the youngest ("newest") revision for the repository.
    def youngest_revision
      @adapter.youngest_revision
    end
    
    # Returns a unified diff of +path+ and +revision+ compared to the last
    # revision (eg. +revision+ - 1). Uses youngest revision if no +revision+
    # is given.
    def udiff(path, revision=nil)
      @adapter.udiff_with_revision(path, revision)
    end
    
  end
end