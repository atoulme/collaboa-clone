# The methods added to this helper will be available to all templates in the application.

gem 'RedCloth'

class Object::Array 
  def cycle() 
    self.each_with_index {|o, i| yield(o, %w(odd even)[i % 2])}
  end
end

module ApplicationHelper
	TICKET_LINK_WORDS = %w(bug ticket)
	CHANGESET_LINK_WORDS = %w(changeset revision rev r)
	TICKET_LINK_PATTERN = /(?:#{TICKET_LINK_WORDS.join('|')}|#)[#\s]*(\d+)/i
	CHANGESET_LINK_PATTERN = /(?:#{CHANGESET_LINK_WORDS.join('|')}|\[)[\s:\[]*(\d+)\]?/i
	
	# Converts tickets and changesets to links
  def make_links(text)
    # Changesets
		text.gsub!(CHANGESET_LINK_PATTERN) do |s|
			if @project && Changeset.find_by_revision_and_repository_id($1, @project.repository.id)
				link_to(s, :controller => 'repository', :action => 'changesets', :id => $1)
			else
				s # Return it unchanged if the pattern matched but it isn't a changeset
			end
		end
		
		# Tickets
    text.gsub!(TICKET_LINK_PATTERN) do |s|
			if Ticket.find_by_id($1) # Only create link if ticket actually exists
				link_to(s, :controller => 'tickets', :action => 'show', :id => $1)
			else
				s # Return it unchanged if it's not a real ticket
			end
		end
		
    return text
  end
  
  def format_and_make_links(text)
    return if text.nil?
    text = RedCloth.new(text, [:hard_breaks, :filter_html]).to_html
    make_links(text)
  end
  
  def login_url
   "#{CAS_BASE_URL}/login" 
  end

  def logout_url
   "#{CAS_BASE_URL}/logout" 
  end

  def menu_item_with_style(link_text, url_params = {}, right = false)
    out = '<li '
    out << 'class="selected"' if params[:controller] == url_params[:controller] && (params[:action] == url_params[:action] || (params[:action] == 'index' && !url_params[:action]))
    out << 'style="float: right"' if right
    out << '>'
    out << link_to(link_text, url_params)
    out << '</li>'
    out
  end
end
