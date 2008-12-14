class RenameVersionsToReleases < ActiveRecord::Migration
  def self.up
    execute "RENAME TABLE versions TO releases;"
    rename_column(:tickets, :version_id, :release_id)
  end

  def self.down
    execute "RENAME TABLE releases TO versions;"
    rename_column(:tickets, :release_id, :version_id)
  end
end
