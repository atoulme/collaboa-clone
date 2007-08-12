module AttachmentsHelper
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
