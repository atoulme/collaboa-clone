class AddResolvedToStatuses < ActiveRecord::Migration
  def self.up
    add_column :ticket_attributes, :resolved, :boolean
  end

  def self.down
    remove_column :ticket_attributes, :resolved
  end
end
