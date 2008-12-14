class User < ActiveRecord::Base
  has_many :rights, :class_name => 'UserProject'
  has_many :projects, :through => :rights, :class_name => "Project"
  has_many :user_rates


  def rights_for(project, create = false)
    return nil if !project
    rights = self.rights.select {|right| right.project == project}.first if self.rights
    if !rights
      rights = UserProject.create({:project_id => project.id, :user_id => id})
      rights.save
      self.rights << rights
      save
    end
    rights
  end
end
