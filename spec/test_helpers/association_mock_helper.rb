class AssociationMock < Array
  def find(*args)
    if args.first == :first
      self.first
    elsif args.first == :all
      self
    end
  end
  alias_method :paginate, :find
  
  def count
    size
  end
end

module AssociationMockHelper
  def mock_association(*records)
    association = AssociationMock.new
    association.concat(records)
    association
  end
end