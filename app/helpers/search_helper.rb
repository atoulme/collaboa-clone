module SearchHelper
  # Highlights the +words+ where they is found in the +text+ by surrounding it like
  # <strong class="highlight">I'm a highlight phrase</strong>. The highlighter can be specialized by
  # passing +highlighter+ as single-quoted string with \1 where the phrase is supposed to be inserted.
  # N.B.: The +words+ is sanitized to include only letters, digits, and spaces before use.
  def hilight_search_terms(text, words, highlighter = '<strong class="highlight">\1</strong>')
    if text.nil? || words.nil? then return end
    unless text.nil?
      CGI::unescape(words) # url un-encode the params
      words.gsub!(/[\+\-\*]/, '') # remove +/- as used by search query
      words.split(' ').each do |w|
        text = text.gsub(/(#{Regexp.escape(w)})/i, highlighter) 
      end
      return text
    end
  end
  
end
