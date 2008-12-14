class Change < ActiveRecord::Base
  belongs_to :changeset
  belongs_to :repository
  
  def unified_diff
    node = self.changeset.repository.fs.repos.get_node(self.path, self.revision)
    #if node.mime_type.match(/^text/)
      #Repository.unified_diff(self.path, self.revision)
      node.udiff_with_revision(self.revision - 1)
    #end
  end
  
  def diffable?
    node = self.changeset.repository.fs.repos.get_node(self.path, self.revision)
    if self.name == 'M' && node.mime_type.match(/^text/)
      return true 
    else
      return false
    end
  end
end
