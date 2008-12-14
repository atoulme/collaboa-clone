#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/../config/environment'

puts "Creating some default severities"
[{:position => 6, :name => "Normal"},
{:position => 5, :name => "Minor"},
{:position => 4, :name => "Enhancement"},
{:position => 3, :name => "Major"},
{:position => 2, :name => "Critical"},
{:position => 1, :name => "Blocker"}].each do |severity|
  Severity.create(severity) unless Severity.find_by_name(severity[:name])
end

puts "Creating some default status"
[{:id => 1, :name => "Open"},
{:id => 2, :name => "Fixed"},
{:id => 3, :name => "Duplicate"},
{:id => 4, :name => "Invalid"},
{:id => 5, :name => "WorksForMe"},
{:id => 6, :name => "WontFix"}].each do |status|
  Status.create(status) unless Status.find_by_name(status[:name])
end

puts "Creating default public user"
User.create(:login => 'Public', 
            :password => 'public',
            :password_confirmation => 'public',
            :view_changesets => 1,
            :view_code => 1,
            :view_milestones => 1,
            :view_tickets => 1,
            :create_tickets => 1,
            :admin => 0 ) unless User.find_by_login('Public')

puts "Creating default admin"
User.create(:login => 'admin', 
            :password => 'admin',
            :password_confirmation => 'admin',
            :view_changesets => 1,
            :view_code => 1,
            :view_milestones => 1,
            :view_tickets => 1,
            :create_tickets => 1,
            :admin => 1 ) unless User.find_by_login('admin')
