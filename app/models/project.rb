class Project < ActiveRecord::Base
  belongs_to :repository
  has_many :tickets
  
  has_many :project_ticket_attributes
  has_many :ticket_attributes, :through => :project_ticket_attributes
  
  has_many :statuses, :through => :project_ticket_attributes, :source => :ticket_attribute, :class_name => 'Status'
  has_many :priorities, :through => :project_ticket_attributes, :source => :ticket_attribute, :class_name => 'Priority'
  has_many :components, :through => :project_ticket_attributes, :source => :ticket_attribute, :class_name => 'Component'
  has_many :releases, :through => :project_ticket_attributes, :source => :ticket_attribute, :class_name => 'Release'
  has_many :milestones
  
  has_many :permissions
  has_many :users, :through => :permissions
  
  def users_with_rejected_public_user
    users = users_without_rejected_public_user
    users.reject {|user| user == User.public_user}
  end
  alias_method_chain :users, :rejected_public_user
  
  def changesets
    self.repository.changesets
  end
end
