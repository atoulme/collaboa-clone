class Addreleaseproperties < ActiveRecord::Migration
  def self.up
    add_column :releases, :download_url, :string
    add_column :releases, :info, :text
  end

  def self.down
    remove_column :releases, :download_url
    remove_column :releases, :info
  end
end
