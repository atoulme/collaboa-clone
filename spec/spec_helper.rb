# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec/rails'
require File.expand_path(File.dirname(__FILE__) + "/test_helpers/authenticated_test_helper")
require 'ostruct'

class AssociationMock < Array
  def find(*args)
    if args.first == :first
      self.first
    elsif args.first == :all
      self
    end
  end
  alias_method :paginate, :find
  
  def count
    size
  end
end

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures'
  # config.before(:each, :behaviour_type => :controller) do
  #     raise_controller_errors
  #   end

  # You can declare fixtures for each behaviour like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so here, like so ...
  #
  #   config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
  
  include AuthenticatedTestHelper
  
  def mock_association(*records)
    association = AssociationMock.new
    association.concat(records)
    association
  end
  
  def mock_user_with_permission_to(permission)
    user = mock_model(User)
    user.should_receive(:has_permission_to?).with(permission, an_instance_of(Hash)).and_return(true)
    user
  end
end
