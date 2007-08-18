class Change < ActiveRecord::Base
  belongs_to :changeset
  
  def diffable?
    return false unless self.status == 'M'
    self.node.mime_type.match(/^text/) ? true : false
  end
  
  def unified_diff
    self.node.udiff_with_revision(self.changeset.revision - 1)
  end
  
  protected
  def node
    self.changeset.repository.backend.node(self.path, self.changeset.revision)
  end
end
