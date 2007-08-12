module TicketsHelper
  def filter_selector(name, attributes)
    return if attributes.empty?
    html = '<dl>'
    html << "<dt>#{name}:</dt>"
    
    selected_filters = filter_conditions_to_a(params[name.downcase])
    
    attributes.each do |attribute|
      html << '<dd>'
      link = link_to_unless(selected_filters.include?(attribute.id), attribute.name, project_tickets_path(:project_id => @project, name.downcase => attribute.id))
      html << link
      
      if selected_filters.include?(attribute.id)
        filters = ''
        
        html << link_to('[-]', project_tickets_path(:project_id => @project, name.downcase => filters)) + ' '
      else
        filter = filter_conditions_as_query
        html << link_to('[+]', project_tickets_path(:project_id => @project, name.downcase => filter)) + ' '
      end
      
      html << '</dd>'
    end
    
    if name == 'Status'
      # TODO: Link to all resolved ids.
      link = link_to('All Resolved')
      html << "<dd>#{link}</dd>"
    end
    
    html << '</dl>'
  end
  
  
  def format_author(author_text)
    author_text
  end
  
  def current_user_author_field(instance_variable_name = 'ticket')
    html = ''
    if logged_in?
      html << text_field_tag('assigned_user_author_text', current_user.login, :disabled => true)
    else
      html << text_field(instance_variable_name, 'public_author_text')
    end
    html
  end
  
  def filter_conditions_to_s(conditions_array)
    return '' unless conditions_array.is_a?(Array)
    conditions_array.map(&:to_i).join(',')
  end
  
  def filter_conditions_to_a(condition_string)
    return [] unless condition_string.is_a?(String)
    condition_string.to_s.split(',').map(&:to_i)
  end
  
  def filter_conditions_as_query
    query_params = {}
    @filter_conditions.each do |attribute_id, filter_values|
      attribute_id =~ /^(\w+)_id$/
      attribute_name = $1
      query_params[attribute_name] = filter_conditions_to_s(filter_values)
    end
    logger.debug "CONDITIONS: #{query_params.inspect}"
    query_params.to_query
  end
end
