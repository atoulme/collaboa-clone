module SVN
  class Status
    class << self
      def statuses
        ['A', 'M', 'D', 'G', 'C', '!', '?', 'X']
      end
      
      def status_name(code)
        status_names = {'A' => 'Added', 'M' => 'Modified', 'D' => 'Deleted', 'G' => 'Merged', 'C' => 'Conflict', '!' => 'Missing', '?' => 'Not In Repository', 'X' => 'External'}
        status_names[code]
      end
    end
    
    def initialize
      load
      self
    end
  
    def reload
      load
      self
    end
    
    attr_accessor :files
    
    def find_by_status(code)
      self.files.select {|file| file.status == code}
    end
    
    def commit
      output = `svn commit`
      output =~ /(Committed revision .*?\.)/m
      puts $1
      
    end
    
    private
    def parse_output
      lines = @output.split("\n")
      lines.each do |line|
        if line =~ /(.)      (.*)/
          @files << File.new($2, $1)
        end
      end
    end
    
    def load
      @output = `svn status`
      @files = []
      parse_output
    end
  end
  
  class File
    include Comparable
    
    def initialize(path, status)
      @path, @status = path, status
    end
    
    attr_accessor :path, :status
    
    def <=>(other_file)
      self.path <=> other_file.path
    end
    
    def add
      `svn add #{self.path}`
    end
    
    def remove
      `svn rm #{self.path}`
    end
    
    def revert
      `svn revert #{self.path}`
    end
    
    def resolve
      `svn resolved #{self.path}`
    end
  end
  
  class Display
    class << self
      def setup(svn_status)
        @svn_status = SVN::Status.new
        clear
      end
      attr_accessor :redisplay_status      
      def grouped_status_list
        SVN::Status.statuses.each do |status|
          display_files_for_status(status)
        end
      end
      
      def display_files(heading, files, options = {})
        default_options = {:display_line_break => true}        
        options = default_options.merge(options)
        
        unless files.empty?
          puts bold(heading)
          files.sort.each do |file|
            display_file(file)
          end
          
          puts '' if options[:display_line_break]
        end
      end
      
      def display_files_for_status(status_code)
        heading = SVN::Status.status_name(status_code)
        files = @svn_status.find_by_status(status_code)
        display_files(heading, files)
      end
      
      def display_file(file)
        puts "#{file.status}      #{file.path}"
      end
      
      def clear
        @clear ||= `clear`
        puts @clear
      end
      
      def bold(text)
        "[1m#{text}[0m"
      end
      
      def ask(text, default, *actions)
        print "#{text} ["
        actions.each do |action|
          action = action.upcase if action == default
          print action
        end
        print '] '
        
        response = gets.chomp.downcase
        return response if actions.include?(response)
        return default.downcase
      end
      
      def specific_list_with_action(title, status, action)
        unless (files = @svn_status.find_by_status(status)).empty?
          if Display.ask(title, 'n', 'y', 'n') == 'y'
            Display.clear
            Display.display_files_for_status(status)

          
            files.sort.each do |file|
              case Display.ask("#{action.to_s.capitalize} #{file.path}", 'n', 'y', 'n', 'q')
                when 'y'
                  file.send(action)
                when 'n'
                  next
                when 'q'
                  break
              end
            end
            
            @svn_status.reload
            self.clear
            self.grouped_status_list
            self.redisplay_status = true
          end
        end
      end
    end
  end
end

include SVN

begin
  svn_status = SVN::Status.new
  redisplay_status = false

  Display.setup(svn_status)
  Display.grouped_status_list
  
  Display.specific_list_with_action('Add items Not in the Repository?', '?', :add)
  Display.specific_list_with_action('Add missing items?', '!', :add)
  Display.specific_list_with_action('Remove missing items?', '!', :remove)
    
  Display.specific_list_with_action('Revert any added items?', 'A', :revert)
  Display.specific_list_with_action('Revert any modified items?', 'M', :revert)
  
  Display.specific_list_with_action('Resolve conflicting items?', 'C', :resolve)
  
  if Display.redisplay_status
    Display.setup(SVN::Status.new)
    Display.grouped_status_list
  end
  
  if Display.ask('Commit Now?', 'y', 'y', 'n') == 'y'
    svn_status.reload.commit
  end
rescue SignalException
  puts ''
  exit
end