class TimeEntries < ActiveRecord::Migration
  def self.up
    create_table :work_entries do |table|
      table.column :ticket_id, :integer
      table.column :project_id, :integer
      table.column :user_id, :integer
      table.column :bill_date, :date
      table.column :start_time, :datetime
      table.column :end_time, :datetime
      table.column :description, :text
      table.column :revision, :integer
      table.column :client_desc, :text
      table.column :rate_multiplier, :float
      table.column :credit_id, :integer
    end

    add_column :tickets, :time_and_materials, :boolean
    add_column :tickets, :estimate, :integer
  end

  def self.down
    drop_table :work_entries
    remove_column :tickets, :time_and_materials
    remove_column :tickets, :estimate
  end
end
