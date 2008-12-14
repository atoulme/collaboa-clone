class Status < ActiveRecord::Base
  has_many :tickets
end
