class Changeset < ActiveRecord::Base
  include Searchable
  belongs_to  :repository
  has_many    :changes, :dependent => :destroy
  has_one     :event, :dependent => :destroy
  
  validates_uniqueness_of :revision, :scope => 'repository_id'
  
  class << self
    def options_for_pagination(project_or_repository)
      options = {:order => 'changesets.revision DESC',
      :include => [:changes]}
      case project_or_repository
      when Project
        project = project_or_repository
        options[:conditions] = options_for_find_by_project(project)[:conditions]
      when Repository
        repository = project_or_repository
        options[:conditions] = ["changesets.repository_id = ?", repository.id]
      end
      options
    end
  
    def find_all_by_project(project)
      self.find(:all, Changeset.options_for_pagination(project) )
    end
    
    def find_all_by_tokens(tokens)
      find( :all,
        :conditions => [(["(LOWER(log) LIKE ?)"] * tokens.size).join(" AND "), 
          *tokens.collect { |token| [token] }.flatten],
        :order => 'created_at DESC')
    end
  
    def options_for_find_by_project(project)
      {:conditions => [ "(changes.path LIKE :root_path OR changes.from_path LIKE :root_path) AND changesets.repository_id = :repository_id", {:root_path => project.root_path + '%', :repository_id => project.repository_id}],
      :include => [:changes]}
    end
  
    def scope_for_find_by_project(project)
      self.options_for_find_by_project(project)
    end
  
    # Syncronizes the database tables as needed with the repos
    # This method should be called from a before filter preferably
    # so that we always are in sync with the repos
    def sync_changesets(verbose=false)
      begin      
        repositories = Repository.find :all  
        repositories.each do |repos|
          Changeset.transaction do
            last_stored = Changeset.find(:first, 
                                          :conditions => ["repository_id = ?", repos.id], 
                                          :order => "revision DESC")
            if last_stored.nil?
              youngest_stored = 0
            else
              youngest_stored = last_stored.revision
            end
            youngest_rev = repos.fs.get_youngest_rev
        
            revs_to_sync = ((youngest_stored + 1)..youngest_rev).to_a
          
            unless revs_to_sync.empty?
              log "Preparing to sync revs #{(youngest_stored + 1)} to #{youngest_rev} for #{repos.name}"
            end
          
             revs_to_sync.each do |rev|
               log "* Syncing r#{rev} for #{repos.name}" if verbose
               revision = repos.fs.get_changeset(rev)
 
               cs = Changeset.new(:revision => rev, 
                                         :author => revision.author,
                                         :log => revision.log_message,
                                         :revised_at => revision.date,
                                         :repository => repos)
 
               revision.copied_nodes.each do |path|
                 cs.changes.build(:revision => rev, :name => 'CP', 
                                 :path => path[0], :from_path => path[1], 
                                 :from_revision => path[2],
                                 :repository => repos )
                 log "  CP #{path[0]} (from #{path[1]}:#{path[2]})" if verbose
               end
 
               revision.moved_nodes.each do |path|
                 cs.changes.build(:revision => rev, :name => 'MV', 
                                 :path => path[0], :from_path => path[1], 
                                 :from_revision => path[2],
                                 :repository => repos)
                 log "  MV #{path[0]} (from #{path[1]}:#{path[2]})" if verbose
               end
 
               revision.added_nodes.each do |path|
                 cs.changes.build(:revision => rev, :name => 'A', :path => path, :repository => repos)
                 log "  A #{path}" if verbose
               end                                                                      
                                                                                
               revision.deleted_nodes.each do |path|                                    
                 cs.changes.build(:revision => rev, :name => 'D', :path => path, :repository => repos)
                 log "  D #{path}" if verbose
               end                                                                      
                                                                                
               revision.updated_nodes.each do |path|                                    
                 cs.changes.build(:revision => rev, :name => 'M', :path => path, :repository => repos)
                 log "  M #{path}" if verbose
               end
       
               cs.save!
       
               log "* Synced changeset #{rev} for #{repos.name}"
             
               # Run GC manually to cut down the memory footprint, 
               # TODO: recheck it on next svn update, current release has known memory issues
               revision = nil
               cs = nil
               GC.start 
               sleep 0.01 
             
             end if youngest_stored < youngest_rev
          end # end transaction
        end # end repositories.each
      rescue ActiveRecord::RecordInvalid => rie
        # just silently ignore it and log it, we only have this one validation for now
        #logger.error rie
        logger.error "Revision already exists!"
      rescue => e
        log e
      end
    end
  
  end # Class methods
  
  private
    def self.log(msg)
      if ENV["COLLABOA_SYNC_RUNNING_INTERACTIVE"] 
        if msg.respond_to? :backtrace # it's most likely an exception
          puts "#{msg.class}: #{msg}"
          puts msg.backtrace
        else
          puts msg
        end
      else
        logger.info msg
      end
    end
  
end