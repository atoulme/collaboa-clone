module TicketsHelper
  def format_author(address)
    address = sanitize(address)
    if address =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/
      mail_to(address, address, :encode => "javascript")
    else
      address
    end
  end
  
  # Creates the row of filter options used to filter the list of tickets.
  # filter_selector(@status, "Status")
  # filter_selector(@users, "Assignment", :assigned_user, :login)
  def filter_selector(collection, name, parameter_name=nil, label_method='name')
    return if collection.empty?
    out = "<dl>"
    out << content_tag('dt', name + ':')
    out += collection.collect do |object|
      content_tag('dd', 
        link_to_unless_current(object.send(label_method), {(parameter_name || name.downcase) => object.id}) + 
        link_to_add_filter(object)
      )
    end.join
    out << content_tag('dd', link_to_unless_current('All resolved', 'status' => -1)) if name == "Status" # Special option for Status
    out + "</dl>"
  end
    
  def link_to_add_filter(object)
    obj_name = object.class.to_s.downcase
    obj_name = 'assigned_user' if obj_name == 'user'
    obj_value = object.id.to_s
    filter_params = {}
    for k,v in request.query_parameters # Have to clone this way or attempts to modify the frozen params
      filter_params[k] = k == obj_name ? Array(v.dup) : v.dup 
    end
    filter_params.delete(:project) # this param is artifically added in the controller
    
    if filter_params.has_key?(obj_name) && filter_params[obj_name].include?(obj_value)
      # Already filtering by this value, so give the option to remove it
      filter_params[obj_name].delete(obj_value)
      symbol = '-'
    else
      filter_params[obj_name] ||= []
      filter_params[obj_name] << obj_value
      symbol = '+'
    end
    if filter_params.reject {|k,v| v == []}.reject {|key, value| /^sort_/ =~ key.to_s }.any?
      link_to("[#{symbol}]", filter_params.reverse_merge(params))
    else
      ''
    end
  end
  
  def render_next_prev_links
    out = %{<div class="ticket-next-prev">}
    out << "<p><small>"
    if @ticket.previous
      out << link_to('Previous', :action => 'show', :id => @ticket.previous)
    end
    if @ticket.next
      out << '|' if @ticket.previous
      out << link_to('Next', :action => 'show', :id => @ticket.next)
    end
    out << "</small></p>\n</div>"
    out 
  end



  def remote_collection_select(object,method,collection, value_method, text_method, options = {}, html_options = {})
    options[:with] = 'Form.serialize(this.form)'
    
    html_options ||= {}
    html_options[:onchange] = "#{remote_function(options)}; return false;"
    
    ActionView::Helpers::InstanceTag.new(object, method, self).
      to_collection_select_tag(collection, value_method, text_method, options, html_options)
    
  end

  def have_filter_parameter?
    request.query_parameters.reject {|key, value| /^sort_/ =~ key.to_s }.any?
  end
end
