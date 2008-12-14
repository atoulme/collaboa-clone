class AddUserRates < ActiveRecord::Migration
  def self.up
    create_table :user_rates do |t|
      t.column :project_id,     :integer, :null => false
      t.column :user_id,        :integer, :null => false
      t.column :start_date,     :datetime
      t.column :end_date,       :datetime
      t.column :rate,           :double
      t.column :description,    :string
    end

    add_column :work_entries, :user_rate_id, :integer
  end

  def self.down
    drop_table :user_rates
    remove_column :work_entries, :user_rate_id
  end
end
