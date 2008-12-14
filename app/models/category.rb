class Category < ActiveRecord::Base
  has_and_belongs_to_many :projects
  belongs_to :parent_category, :class_name => "Category", :foreign_key => 'parent'
end
