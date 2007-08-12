# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def page_title(title)
    content_for(:page_title) {title}
  end
  
  def format_and_make_links(text)
    text
  end
    
  def include_javascripts_for_controller
    html = ''
    javascripts = [controller.controller_name, File.join(controller.controller_name, controller.action_name)]
    javascripts.map! {|js| "#{js}.js"}
    javascripts.each do |js_file|
      if File.exists?(File.join(RAILS_ROOT, 'public', 'javascripts', js_file))
        html << javascript_include_tag(js_file)
      end
    end
    html
  end
end
