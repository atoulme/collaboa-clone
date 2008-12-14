module Searchable
  module ClassMethods
    # Token finder code based on things found in Typo
    def search(query, project=nil)
      return [] if query.to_s.strip.empty? # Empty search yields 0 results
      tokens = query.split.collect {|c| "%#{c.downcase}%"}
      if project
        self.with_scope(:find => scope_for_find_by_project(project)) do
          find_all_by_tokens(tokens)
        end
      else
        find_all_by_tokens(tokens)
      end
    end
  end
  
  extend ClassMethods
  
  def self.included(receiver)
    receiver.extend(ClassMethods)
  end
  
  
end