module TicketsHelper
  def filter_selector(name, attributes)
    return if attributes.empty?
    html = '<dl>'
    html << "<dt>#{name}:</dt>"
    
    attributes.each do |attribute|
      html << '<dd>'
      link = link_to_unless(@filter_conditions.include?(attribute), attribute.name, project_tickets_path(:project_id => @project, name.downcase => attribute.id))
      html << link
      
      other_url_options = {:project_id => @project, :sort_by => params[:sort_by], :order => params[:order]}
      if @filter_conditions.include?(attribute)
        link = link_to('[-]', project_tickets_path(@filter_conditions.to_query_without(attribute).merge(other_url_options)))
      else
        link = link_to('[+]', project_tickets_path(@filter_conditions.to_query_with(attribute).merge(other_url_options)))
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
  
  # Display a <th> with links and class names used for sorting.
  def sort_header(header, options = {})
    sort_key = options.delete(:sort_key) || header.downcase
    
    # If the current header is already sorted ascending, we want to display descending next time.
    if (params[:sort_by] == sort_key) && (params[:order] == 'ASC')
      order = 'DESC'
    else
      order = 'ASC'
    end
    
    # Add class to display sorted arrow if the current header is sorted
    options[:class] << " #{params[:order].downcase}" if (params[:sort_by] == sort_key)
    
    # Display a link to order the table with the current filter selected.
    link = link_to(header, @filter_conditions.to_query.merge(:project_id => @project, :sort_by => sort_key, :order => order))
    content_tag(:th, link, options)
  end
end
