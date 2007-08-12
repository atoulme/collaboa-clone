# Default priorities.
%w(Normal Major Minor Enhancement Critical Blocker).each do |priority|
  Priority.create(:name => priority) unless Priority.find_by_name(priority)
end

# Default statuses
['Open', 'Fixed', 'Duplicate', 'Invalid', 'Works For Me', 'Wont Fix'].each do |status|
  Status.create(:name => status) unless Status.find_by_name(status)
end