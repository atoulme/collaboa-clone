# Be sure to restart your webserver when you modify this file.

# Uncomment below to force Rails into production mode
# (Use only when you can't set environment variables through your web/app server)
# ENV['RAILS_ENV'] = 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.1'

#The forge name. This constant is used everywhere.
FORGE_NAME = 'Grunt Forge'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Skip frameworks you're not going to use
  config.frameworks -= [ :action_mailer ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/app/services )

  # Force all environments to use the same logger level 
  # (by default production uses :info, the others :debug)
  config.log_level = :debug

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake create_sessions_table')
  config.action_controller.session_store = :active_record_store

  # Enable page/fragment caching by setting a file-based store
  # (remember to create the caching directory and make it readable to the application)
  # config.action_controller.fragment_cache_store = :file_store, "#{RAILS_ROOT}/cache"

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  config.active_record.default_timezone = :utc
  
  # Use Active Record's schema dumper instead of SQL when creating the test database
  # (enables use of different database adapters for development and test environments)
  config.active_record.schema_format = :ruby

  # See Rails::Configuration for more options
  config.load_paths << "#{RAILS_ROOT}/vendor/syntax/lib"
end

gem 'RedCloth', '~> 3.2' 


# Add new inflection rules using the following format 
# (all these examples are active by default):
# Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

Inflector.inflections do |inflect|
  inflect.uncountable %w( status )
end

# Include your application configuration below
require 'collaboa/lib/setup'
Collaboa::Setup.run do |config|
  # Set whether subversion support is enabled. Defaults to true.
  # config.subversion_support = false
  
  # Set the attachments path. Defaults to RAILS_ROOT/attachments.
  # config.attachments_path = File.join(RAILS_ROOT, 'attachments')
end

include REXML

# Tell Rake and the fixtures where to prepare a test SVN repository
TEST_REPOS_PATH = "#{RAILS_ROOT}/tmp/test_repos" if Collaboa::CONFIG.subversion_support

FIELD_NAME = {
  "Severity" => "Priority",
  "Severities" => "Priorities",
  "Part" => "Component",
  "Parts" => "Components"
}

# Allow session path to be set automatically.  See http://dev.rubyonrails.org/ticket/7203
ActionController::Base.session_options[:session_path] =  nil
# Unique session key.
ActionController::Base.session_options[:session_key] = '_collaboa_session_id'

#require 'casclient'
#require 'casclient/frameworks/rails/filter'

# enable detailed CAS logging
cas_logger = CASClient::Logger.new(RAILS_ROOT+'/log/cas.log')
cas_logger.level = Logger::DEBUG
CAS_BASE_URL = "https://cas.intalio.com:443"

CASClient::Frameworks::Rails::Filter.configure(
  :cas_base_url => CAS_BASE_URL,
  :logger => cas_logger,
  :login_url => "#{CAS_BASE_URL}/login",
  :logout_url => "#{CAS_BASE_URL}/logout"
)

gem 'mislav-will_paginate', '~> 2.3'
require 'will_paginate'


