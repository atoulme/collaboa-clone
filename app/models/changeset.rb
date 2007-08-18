class Changeset < ActiveRecord::Base
  belongs_to :repository
  has_many :changes, :dependent => :destroy
  
  cattr_reader :per_page
  @@per_page = 15
  
  def to_param
    self.revision.to_s
  end
end
