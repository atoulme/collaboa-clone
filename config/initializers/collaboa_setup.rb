module Collaboa
  class Setup
    def self.run(configuration = Configuration.new)
      yield configuration if block_given?
      
      Collaboa.const_set('CONFIG', configuration)
      configuration
    end
  end
  
  class Configuration
    # Determines whether to enable subversion support. This should be set to false if SWIG and the SVN-ruby bindings are
    # not installed
    attr_accessor :subversion_support
    
    # Sets where the attachments should be saved.
    attr_accessor :attachments_path
    
    # Sets up some default configuration values.
    def initialize
      self.subversion_support = default_subversion_support
      self.attachments_path = default_attachments_path
    end
    
    def default_subversion_support
      true
    end
    
    def default_attachments_path
      File.join(RAILS_ROOT, 'attachments')
    end
  end
end