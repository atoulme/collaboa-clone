ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class Test::Unit::TestCase
  # Turn off transactional fixtures if you're working with MyISAM tables in MySQL
  self.use_transactional_fixtures = true
  
  # Instantiated fixtures are slow, but give you @david where you otherwise would need people(:david)
  self.use_instantiated_fixtures  = false

  # Add more helper methods to be used by all tests here...
  
  def login_as(user)
    @request.session[:user] = user.id
  end
end

module Test::Unit::Assertions
  def make_ruby_array str
    "[\"" + str.split("\n").join("\",\n\"") +"\"]"
  end

  def assert_multi(expected, actual, message=nil)
    if expected.kind_of? Array
      expected = expected.collect {|i| i+"\n"}.join("")
    end
    full_message = build_message(message, <<EOT)
#{make_ruby_array expected}
expected but was
#{make_ruby_array actual}
EOT
    assert_block(full_message) { expected == actual }
  end
end
