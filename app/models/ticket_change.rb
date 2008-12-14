class TicketChangeLogEntry
  attr_reader :attribute, :old_value, :new_value

  def initialize(attribute, old_value, new_value)
    @attribute = attribute
    @old_value = old_value
    @new_value = new_value
  end

  def htmlize(text)
    return if text.nil?
    text.gsub!("<", "&lt;")
    text.gsub!(">", "&gt;")   
    text = RedCloth.new(text).to_html 
    return text
  end

  def format_changes_with_diff
    odoc = Document.new
    odoc << (Element.new 'html')
    odoc.root.add_namespace('http://www.w3.org/1999/xhtml')
    odoc.root << (head = Element.new 'head')
    head << (title = Element.new 'title')
    title << REXML::Text.new("Diff of #{ARGV[0]} and #{ARGV[1]}")
    odoc.root << (body = Element.new 'body')
    
    hd = XHTMLDiff.new(body)
    a = "<html><body>#{htmlize(@old_value)}</body></html>"
    b = "<html><body>#{htmlize(@new_value)}</body></html>"
    a = HashableElementDelegator.new(XPath.first(Document.new(a),'/html/body'))
    b = HashableElementDelegator.new(XPath.first(Document.new(b),'/html/body'))
    
    Diff::LCS.traverse_balanced(a, b, hd)
    
    s = StringIO.new
    require 'rexml/formatters/default'
    require 'rexml/document'
    bar = REXML::Formatters::Default.new
    out = String.new
    bar.write(XPath.first(odoc,'/html/body/'), s)

    # deprecated, we should use a formatter instead
    #XPath.first(odoc,'/html/body/').write(s, 0, false, true)
    
    s.string =~ /<body>(.*)<\/body>/m
    "<li><strong>#{@attribute}</strong> changed:</li><div class=\"ticketdiff\">#{$1}</div>"
  end

  def format_changes_simple
    "<strong>#{attribute}</strong> changed from <em>#{old_value}</em> to <em>#{new_value}</em>"
  end

  def format_changes
    if attribute == "Content"
      format_changes_with_diff
    else
      format_changes_simple
    end
  end
end

class TicketChange < ActiveRecord::Base
  include Searchable
  belongs_to  :ticket
  has_one     :event, :dependent => :destroy
  serialize :log

  def date_of_change
    Time.local(created_at.year, created_at.month, created_at.day,0,0,0)
  end
  
#   def after_save
#     # TODO: This should be in an observer
#     # TODO: change :title if closed etc accordingly
#     Event.create( :project_id => self.ticket.project_id,
#                   :title => "Ticket ##{self.ticket_id} modified by #{self.author}",
#                   :content => nil,
#                   :ticket_change_id => self.id,
#                   :created_at => self.created_at,
#                   :link => {:controller => 'tickets', 
#                             :action => 'show', 
#                             :id => self.ticket_id } )
#   end
  
  def each_log
    return unless self.log
    self.log.each do |name, (old_value, new_value)|
      yield TicketChangeLogEntry.new(name, old_value, new_value)
    end
  end
  
  def empty?
    return false if self.comment && !self.comment.empty?
    return false if self.log && !self.log.empty?
    return false if self.attachment && !self.attachment.empty?
    true
  end
  
  # TODO: flesh out
  def attach(attachment)
    unless attachment.blank?
      self.attachment = base_part_of(attachment.original_filename)
      self.content_type = attachment.content_type.strip
      self.attachment_fsname = dump_filename
      filename = dump_filename
      attachment.rewind
      File.open(filename, "wb") do |f|
        f.write(attachment.read)
      end
    end
  end
  
  def dump_filename
    File.expand_path(File.join(Collaboa::CONFIG.attachments_path, "#{self.id}-#{self.attachment}"))
  end  
  
  def has_attachment?
    self.attachment && !self.attachment.empty?
  end

  def matches(str)
    arr = []
    scan = StringScanner.new(str)
    while x= scan.scan(/.*?((<(del|ins)>)(.*?)(<\/(del|ins)>))/m)
      arr << scan[2] + scan[4].gsub(/<\/?.*?>/m,"") + scan[5]
    end
    arr
  end

  def format_changes_one_line
    str = ""
    each_log do |change|
      if change.attribute == "Content" 
        str += matches(change.format_changes_with_diff).join(" ").gsub(/del/m,"strike").gsub(/<\/?ins>/m,"")
      else 
        str += "#{change.attribute} changed from <em>#{change.old_value}</em> to <em>#{change.new_value}</em> "
      end 
    end 
    str
  end
  
  class << self    
    def find_all_by_tokens(tokens)
      find( :all,
        :conditions => [(["(LOWER(comment) LIKE ?)"] * tokens.size).join(" AND "), *tokens.collect { |token| [token] }.flatten],
        :order => 'ticket_changes.created_at DESC')
    end
    
    def scope_for_find_by_project(project)
      { :conditions => ["tickets.project_id = ?", project.id], :include => :ticket }
    end
  end
  
  protected
    validates_presence_of :author

  private
    def base_part_of(filename)
      filename = File.basename(filename.strip)
      # remove leading period, whitespace and \ / : * ? " ' < > |
      filename = filename.gsub(%r{^\.|[\s/\\\*\:\?'"<>\|]}, '_')
    end

end
