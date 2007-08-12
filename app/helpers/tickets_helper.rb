module TicketsHelper
  def filter_selector(name, attributes)
    return if attributes.empty?
    html = '<dl>'
    html << "<dt>#{name}:</dt>"
    
    attributes.each do |attribute|
      html << '<dd>'
      link = link_to_unless(@filter_conditions.include?(attribute), attribute.name, project_tickets_path(:project_id => @project, name.downcase => attribute.id))
      html << link
      
      if @filter_conditions.include?(attribute)
        link = link_to('[-]', project_tickets_path(@filter_conditions.to_query_without(attribute).merge(:project_id => @project)))
      else
        link = link_to('[+]', project_tickets_path(@filter_conditions.to_query_with(attribute).merge(:project_id => @project)))
      end
      
      link.gsub!('%2C', ',')
      html << "#{link} </dd>"
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
end
