class Subcomponents < ActiveRecord::Migration
  def self.up
    add_column :parts, :parent_id, :integer
    parts = Part.find(:all)
    root = Part.create :name => '___root___'
    parts.each do |p|
      p.parent_id = root.id
      p.save
    end
  end

  def self.down
    # looks rather hack-ish...but who cares as long as it works :)
    root = Part.find_by_parent_id(nil)
    Part.find(:all).each do |p|
      p.parent_id = nil
      p.save
    end
    root.destroy
    remove_column :parts, :parent_id
  end
end
