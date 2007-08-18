class Repository < ActiveRecord::Base
  belongs_to :project
  has_many :changesets
  
  def backend
    @repos ||= Cscm::Repository.new(self.path, :subversion)
  end
end
