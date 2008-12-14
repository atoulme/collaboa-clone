class Severity < ActiveRecord::Base
  has_many :tickets

  def formatted_desc
    name
  end
end
