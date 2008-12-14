class Project < ActiveRecord::Base
  has_many :rights, :class_name => 'UserProject'
  has_many :users, :through => :rights, :class_name => "User"
  belongs_to :repository
  has_many :events, :order => "created_at DESC"
  has_many :tickets
  has_many :ticket_changes, :through => :tickets
  has_many :milestones
  has_many :releases
  has_many :parts, :order => "name"
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :tags
  before_validation :format_root_path

  alias :ticket_changes :changes
  
  def to_param
    self.short_name
  end

  def before_save    
    if self.name 
      result = self.name.downcase
      result.gsub!(/['"]/, '')      # replace quotes by nothing
      result.gsub!(/\W/, ' ')       # strip all non word chars
      result.gsub!(/\ +/, '-')      # replace all white space sections with a dash
      result.gsub!(/(-)$/, '')      # trim dashes
      result.gsub!(/^(-)/, '')
      
      self.short_name = result
    end
  end

  def Project.show_for_user(current_user)
    Project.find(:all, :conditions => "closed = 'f'")
  end
 
  #deprecated stuff 
  def relativize_svn_path(path)
    path = path.join("/")  if (path && (path.is_a? Array))
    path ||= ''
    path.gsub(/^\/?#{self.root_path}\/?/, '')
    path
  end
  
  def absolutize_svn_path(path)
    path = path.join("/")  if (path && (path.is_a? Array))
    path ||= ''
    self.root_path.blank? ? path : File.join(self.root_path, path)
  end
  
  protected
  def format_root_path
    unless self.root_path.blank?
      self.root_path.strip!
      self.root_path.gsub!(/^\//, '')
      self.root_path = self.root_path + '/' unless self.root_path =~ /\/$/
    end
  end
end
