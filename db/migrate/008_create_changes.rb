class CreateChanges < ActiveRecord::Migration
  def self.up
    create_table :changes do |t|
      t.integer :changeset_id
      t.string :path
      t.string :status
      t.string :from_path
      t.integer :from_revision
      t.timestamps 
    end
  end

  def self.down
    drop_table :changes
  end
end
