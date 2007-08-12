# A presenter class for handling the filtering of tickets based on given paramaters.
class TicketFilterConditions
  def initialize(params)
    @params = params
    @conditions = {}
  end
  
  # Set the default conditions if no conditions are given.
  def default_conditions
    {:status => Status.unresolved_status_ids}
  end
  
  # Determines whether we want to use the default condtions for this query.
  def default?
    @conditions.empty?
  end
  
  # Adds which paramaters to filter by. 
  def filter_by(*attributes)
    attributes.each do |attribute|
      @conditions[attribute] = @params[attribute].split(',').map!(&:to_i) if @params[attribute]
    end
  end
  
  # Check whether these conditions have selected the given TicketAttribute
  def include?(ticket_attribute)
    attribute_name = attribute_name_for(ticket_attribute)
    if @conditions[attribute_name]
      @conditions[attribute_name].include?(ticket_attribute.id) ? true : false
    else
      false
    end
  end
  
  # Converts the given conditions into a Hash, that can be based to an ActiveRecord::Base.find query.
  def to_sql_conditions
    if default?
      conditions = default_conditions 
    else
      conditions = @conditions
    end
    
    sql_conditions = {}
    conditions.each {|attribute, values| sql_conditions["#{attribute}_id"] = values}
    return sql_conditions
  end
  
  # Converts the given conditions into a Hash, that can be used with *_path route helper. It also adds the given
  # attribute to the list of conditions.
  def to_query_with(attribute)
    to_query do |conditions|      
      attribute_name = attribute_name_for(attribute)
      if conditions[attribute_name]
        conditions[attribute_name] << attribute.id
      else
        conditions[attribute_name] = [attribute.id]
      end
    end
  end
  
  # Converts the given conditions into a Hash, that can be used with *_path route helper. It also removes the given
  # attribute in the list of conditions.
  def to_query_without(attribute)
    to_query do |conditions|
      attribute_name = attribute_name_for(attribute)
      if conditions[attribute_name].size == 1
        conditions.delete(attribute_name)
      else
        conditions[attribute_name].delete(attribute.id)
      end
    end
  end
  
  protected
  # Converts a TicketAttribute to a name used in the @conditions hash.
  def attribute_name_for(attribute)
    attribute.is_a?(User) ? :assigned_user : attribute.class.name.downcase.to_sym
  end
  
  # Converts the given conditions into a Hash, that can be used with *_path route helper.
  def to_query
    query = {}
    
    # Do a deep clone, so we don't affect the query for other links
    conditions = @conditions.clone
    conditions.each_key do |key|
      conditions[key] = conditions[key].clone
    end
    
    yield conditions if block_given?
    
    conditions.each do |attribute, values|
      query[attribute] = values.uniq.join(',')
    end
    return query
  end
end