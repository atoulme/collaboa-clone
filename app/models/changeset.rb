class Changeset < ActiveRecord::Base
  belongs_to :repository
  
  cattr_reader :per_page
  @@per_page = 15
  
  def to_param
    self.revision.to_s
  end
  
  # TODO: Implement
  def changes
    change1 = OpenStruct.new
    change1.name = 'Added'
    change1.status = 'A'
    
    change2 = OpenStruct.new
    change2.name = 'Modified'
    change2.status = 'M'
    
    change3 = OpenStruct.new
    change3.name = 'Deleted'
    change3.status = 'D'
    
    [change1, change2, change3]
  end
end
