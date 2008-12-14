class Ticket < ActiveRecord::Base
  include Searchable
  belongs_to  :milestone
  belongs_to  :part
  belongs_to  :severity
  belongs_to  :status
  belongs_to  :release
  belongs_to  :project
  has_many    :ticket_changes, :order => 'created_at', :dependent => :destroy
  has_many    :child_tickets, :order => 'created_at', :dependent => :destroy, :class_name => "Ticket", :foreign_key => "parent_id"
  belongs_to  :parent, :class_name => "Ticket", :foreign_key => "parent_id"
  has_one     :event, :dependent => :destroy
  belongs_to  :assigned_user, :class_name => "User", :foreign_key => "assigned_user_id"

#  attr_protected :author
  
  def before_save
    self.status ||= Status.find(1)
    self.severity ||= Severity.find(1)
  end

  def formatted_desc
    summary
  end

  def title
    summary
  end

  # Overriding save to allow for creating the TicketChange#log if we're
  # editing a ticket
  # Returns the normal save if +params+ is nil or self.new_record=true
  def save(params=nil)
    if self.new_record? 
      return false unless super()

      change = TicketChange.new({})
      change.comment = "Created"
      change.author = author
      self.ticket_changes << change
      return change.save
    end

    return super() if params.nil? or not params

    self.attributes = params[:ticket]
    return false unless super()

    change = TicketChange.new(params[:change])

    self.ticket_changes << change
    change.log = @log
    change.attach(params[:change][:attachment]) unless params[:change][:attachment].blank?

    if change.empty?
      self.errors.add_to_base 'No changes has been made' 
      self.ticket_changes.delete(change)  
      change.destroy
      return nil
    else
      change.save
    end
  end
  
  class << self
    def find_all_by_tokens(tokens)
      find( :all, 
        :conditions => [(["(LOWER(summary) LIKE ? OR LOWER(content) LIKE ?)"] * tokens.size).join(" AND "), *tokens.collect { |token| [token] * 2 }.flatten],
        :order => 'created_at DESC')
    end
    
    def scope_for_find_by_project(project)
      { :conditions => ["project_id = ?", project.id] }
    end
    
    # Find a bunch of Tickets from a hash of SQL-like fragments. Silently discards
    # everything we don't want. Accepts +order_by+, +direction+ and +limit+ to limit/order
    # the results (eg from a table sort etc)
    def find_by_filter(params = nil, order_by = 'created_at desc', limit = '')
      filters = []
      good_fields = %w{milestone part severity release status assigned_user}
      good_sort_fields = ["id","summary"] + good_fields.map{|f| "#{f}_id"}
      params.stringify_keys.each do |field, value|
        subfilters = []
        Array(value).each do |value|
          subfilters << condition_for_filter_param(field, value) 
        end
        filters << '(' + subfilters.join(' OR ') + ')'  if good_fields.include? field
      end
      
      # sanitize sorting+direction param, silently defaulting to descending if we don't like it
      order_by = order_by.split(" ")
      direction = order_by.pop
      direction = 'DESC' unless %w{ASC DESC}.include? direction.upcase
      order_by = ["id"] unless good_sort_fields.include?(order_by.first)
      order_by = (order_by << direction).join(" ")
      find_by_sql %{SELECT tickets.*, 
                            status.name AS status_name, 
                            severities.name AS severity_name,
                            parts.name AS part_name,
                            milestones.name AS milestone_name,
                            releases.name AS release_name  
                    FROM tickets  
                    LEFT OUTER JOIN severities ON severities.id = tickets.severity_id 
                    LEFT OUTER JOIN status ON status.id = tickets.status_id
                    LEFT OUTER JOIN parts ON parts.id = tickets.part_id 
                    LEFT OUTER JOIN milestones ON milestones.id = tickets.milestone_id 
                    LEFT OUTER JOIN releases ON releases.id = tickets.release_id 
                    #{'WHERE ' + filters.join(' AND ') unless filters.empty?}
                    ORDER BY tickets.#{order_by} }
    end
  end

  def formatted_label
    summary
  end
  
  protected
    validates_presence_of :author, :summary, :content
    
    LOG_MAP = {
      'assigned_user_id' => ['Assigned to', 'Unspecified', lambda{|v| User.find(v).login if v > 0}],
      'part_id' => [FIELD_NAME['Part'], 'Unspecified', lambda{|v| Part.find(v).name if v > 0}],
      'release_id' => ['Release', 'Unspecified', lambda{|v| Release.find(v).name if v > 0}],
      'severity_id' => [FIELD_NAME['Severity'], nil, lambda{|v| Severity.find(v).name if v > 0}],
      'status_id' => ['Status', nil, lambda{|v| Status.find(v).name if v > 0}],
      'milestone_id' => ['Milestone', 'Unspecified', lambda{|v| Milestone.find(v).name if v > 0}],
      'summary' => ['Summary', nil, lambda{|v| v unless v.empty?}],
      'content' => ['Content', nil, lambda{|v| v unless v.empty?}],
    }
  
    # This cool write_attribute override is courtesy of Kent Sibilev
    def write_attribute(name, value)
      @log ||= {}

      if converter = LOG_MAP[name]
        old_value = read_attribute(name)

        column = column_for_attribute(name)
        if column
          if value == "" && column.type == :integer
            value = nil
          else
            value = column.type_cast(value) rescue value
          end
        end

        loader = lambda{ |v|
          result = converter[2][v] if v
          result = converter[1] unless result
          result
        }

        if old_value != value
          @log[converter[0]] = [loader[old_value], loader[value]]
        end
      end

      super
    end

    def self.condition_for_filter_param(field, value)
      if field == 'status' && (value.to_i) == -1
        operator = ' >= '
        value = 2
      else
        operator = ' = '
      end
      "tickets.#{field}_id" + operator + sanitize(value.to_i)
    end
end
