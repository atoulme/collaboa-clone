class Repository < ActiveRecord::Base
  validates_presence_of :name, :path  
  has_many :changes
  has_many :changesets
  has_many :projects

  # Attempt to dispatch to ActionSubversion::Base (what a dumb hack this turned out to be /JS)
  #def method_missing(method_name, *args)
  #  unless self.attributes.include?(method_name.to_s) or 
  #  (method_name.to_s =~ /^find\w*/) or 
  #  (method_name.to_s =~ /before_type_cast$/)
  #    ActionSubversion::Base.repository_path = self.attributes['path']#self.path
  #    ActionSubversion::Base.send(method_name, *args)
  #  else
  #    super
  #  end
  #end
  
  def fs
    ActionSubversion::Base.repository_path = self.path
    ActionSubversion::Base
  end
  
end
