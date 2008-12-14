class Part < ActiveRecord::Base
  has_many :tickets
  belongs_to :project
end
