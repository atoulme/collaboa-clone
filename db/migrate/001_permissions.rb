class Permissions < ActiveRecord::Migration
  def self.up
    add_column :users, :view_changesets, :boolean, :default => 1
    add_column :users, :view_code, :boolean, :default => 1
    add_column :users, :view_tickets, :boolean, :default => 1
    add_column :users, :create_tickets, :boolean, :default => 1
    add_column :users, :admin, :boolean, :default => 0

    User.reset_column_information
    #User.find(:all).each { |u| u.admin = 1; u.save }
    #u = User.find(:first); u.admin=1; u.save!
    User.create :login => 'Public', :password => 'nothing', :password_confirmation => 'nothing'
  end

  def self.down
    remove_column :users, :view_changesets
    remove_column :users, :view_code
    remove_column :users, :view_tickets
    remove_column :users, :create_tickets
  end

end
