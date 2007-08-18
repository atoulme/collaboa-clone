class Repository < ActiveRecord::Base
  belongs_to :project
  has_many :changesets, :order => 'revision DESC' do
    def latest_revision
      latest_changeset = find(:first, :order => 'revision DESC')
      latest_changeset ? latest_changeset.revision : nil
    end
  end
  
  def self.sync
    find(:all).each {|repository| repository.sync}
  end
  
  def sync
    latest_synced_revision = self.changesets.latest_revision || 0
    latest_revision = self.backend.youngest_revision
    
    return if latest_synced_revision && latest_synced_revision == latest_revision
    
    revisions_to_sync = ((latest_synced_revision+1)..latest_revision)
    revisions_to_sync.each do |revision_number|
      revision = self.backend.changeset(revision_number)
      
      changeset = Changeset.new(:revision => revision_number,
                                :author => revision.author,
                                :log => revision.log,
                                :revised_at => revision.date,
                                :repository => self)
                                
      # TODO: Refactor, to make it more DRY
      revision.added_nodes.each do |path|
        changeset.changes.build(:status => 'A', :path => path)
      end
      
      revision.updated_nodes.each do |path|
        changeset.changes.build(:status => 'M', :path => path)
      end
      
      revision.deleted_nodes.each do |path|
        changeset.changes.build(:status => 'D', :path => path)
      end
      
      revision.moved_nodes.each do |path_details|
        new_path = path_details[0]
        old_path = path_details[1]
        from_revision = path_details[2]
        
        changesets.changes.build(:status => 'MV',
                                 :path => new_path, :from_path => old_path,
                                 :from_revision => from_revision)
      end
      
      revision.copied_nodes.each do |path_details|
        new_path = path_details[0]
        old_path = path_details[1]
        from_revision = path_details[2]
        
        changesets.changes.build(:status => 'CP',
                                 :path => new_path, :from_path => old_path,
                                 :from_revision => from_revision)
      end
      
      changeset.save!
    end
  end
  
  def backend
    @repos ||= Cscm::Repository.new(self.path, :subversion)
  end
end
