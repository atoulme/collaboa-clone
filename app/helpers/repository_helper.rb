module RepositoryHelper

  def change_map(change_name)
    changed_type = {
      'M' => 'Updated',
      'A' => 'Added',
      'D' => 'Deleted',
      'CP'=> 'Copied',
      'MV'=> 'Moved'
    }
    changed_type[change_name]
  end

  # returns and unordered list with clickable path parts
  def path_breadcrumbs(paths, last_element_clickable=false)
    links = []
    links << link_to('root', :action => 'browse', :path => current_project ? current_project.root_path.split("/") : nil)
    path = []
    paths.each_with_index do |p,i|
      path << p
      if current_project && (path.join("/").start_with? current_project.root_path)
        if i == paths.length - 1 and not last_element_clickable
          link = p
        else
          link = link_to(p, :action => 'browse', :path => path)
        end
        links << link 
      end
    end
    res = ""
    addDelimiter = false
    for link in links
      res += "<li>"
      res += "&#187" if addDelimiter
      addDelimiter = true
      res += link
      res += "</li>"
    end
    "<ul>#{res}</ul>" 
  end
  
  # Takes a unified diff as input and renders it as html
  def render_diff(udiff)
    return if udiff.blank?
    out = "<table class=\"codediff\">\n"
    
    lines = udiff.split("\n")
    
    lines_that_differs = /@@ -(\d+),?(\d*) \+(\d+),?(\d*) @@/
    
    out << "<thead>\n"
    out << "\t<tr><td class=\"line-numbers\">prev.</td><td class=\"line-numbers\">current</td><td>&nbsp</td></tr>\n"
    out << "</thead>\n"

    prev_counter = 0
    cur_counter = 0
    change_num = 0

    lines[2..lines.length].each do |line|      
      if line_nums = line.match(lines_that_differs)      
      	prev_line_numbers = line_nums[1].to_i...(line_nums[1].to_i + (line_nums[2]).to_i)
        cur_line_numbers = line_nums[3].to_i...(line_nums[3].to_i + (line_nums[4]).to_i)
        prev_counter = prev_line_numbers.first - 1
        cur_counter = cur_line_numbers.first - 1
        change_num += 1 
      end
      
      line = h(line)
      line.gsub!(/^\s/, '') # The column where + or - would be
      line.gsub!(/^(\+{1}(\s+|\t+)?(.*))/, '\2<ins>\3</ins>')
      line.gsub!(/^(-{1}(\s+|\t+)?(.*))/, '\2<del>\3</del>')
      line.gsub!('\ No newline at end of file', '')

      out << "<tr class=\"changes\">\n"
      
      if line.match(/^(\s+|\t+)?<del>/) 
        out << "\t<td class=\"line-numbers\">" + prev_counter.to_s + "</td>\n"
        out << "\t<td class=\"line-numbers\">&nbsp;</td>\n"
        prev_counter += 1
        action_class = 'del'
      elsif line.match(/^(\s+|\t+)?<ins>/)
        out << "\t<td class=\"line-numbers\">&nbsp;</td>\n"
        out << "\t<td class=\"line-numbers\">" + cur_counter.to_s + "</td>\n"
        cur_counter += 1 
        action_class = 'ins'
      else
        if line.match(lines_that_differs)
          line = ''
          if change_num > 1
            out << "\t<td class=\"line-numbers line-num-cut\">...</td>\n"
            out << "\t<td class=\"line-numbers line-num-cut\">...</td>\n"
            action_class = 'cut-line'
          else 
            out << "\t<td class=\"line-numbers\"></td>\n"
            out << "\t<td class=\"line-numbers\"></td>\n"
            action_class = 'unchanged'
          end
        else
          out << "\t<td class=\"line-numbers\"></td>\n"
          out << "\t<td class=\"line-numbers\"></td>\n"
          action_class = 'unchanged'
        end
        prev_counter += 1 
        cur_counter += 1 
      end
      
      out << "\t<td class=\"code #{action_class}\">" + line + "</td></tr>\n"     
    end
    out << "\n</table>\n"
  end
  
  def highlight(content, mime_type)
    # prepare the hash of mime_types to tokenizer types
    # TODO: Create more Syntax defs, and/or fix the xml highlighter to be more forgiving
    mime_tokenizers = { 'text/xml' => 'xml',  
                        #'text/x-html+ruby' => 'xml', # .rhtml
                        #'text/html' => 'xml',
                        'text/x-ruby' => 'ruby',
                        'text/x-yaml' => 'yaml',
                        #'text/css' => 'yaml'
                      }
    type = mime_tokenizers[mime_type]
    return make_line_nums(h(content)) unless Syntax::SYNTAX.has_key? type
     
    converted = Syntax::Convertors::HTML.for_syntax(type).convert(content,false)
    make_line_nums(converted, type)
  end
  
  def make_line_nums(contents, css_class="")
    line_num = 1
    html = "<table class=\"#{css_class}\">\n"
    contents.each_line do |content|
      html << "<tr>\n"
      html << '  <td class="line-numbers">' + line_num.to_s + "</td>\n"
      html << '  <td class="code">' + content + "</td>\n"
      html << "</tr>\n"
      line_num += 1
    end
    html << '</table>'      
  end

end
