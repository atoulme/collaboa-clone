# FIXME: Need an if Collaboa::CONFIG.subversion_support somewhere here?
namespace :test do
  task :units => "repository:test:prepare"
  task :functionals => "repository:test:prepare"
  task :integration => "repository:test:prepare"
end

namespace :repository do
  namespace :test do
    desc "Prepare the test repository and load the fixture"
    task :prepare => [:clobber, :environment] do
      # FIXME: This should probably be done in pure Ruby, but testing against a live
      # repository may go away shortly anyway.
      system "svnadmin create #{TEST_REPOS_PATH}"
      system "svnadmin load -q #{TEST_REPOS_PATH} < #{RAILS_ROOT}/lib/actionsubversion/test/fixtures/data_for_tests.svn"
    end
    
    desc "Delete the test repository"
    task :clobber => :environment do
      system "rm -rf #{TEST_REPOS_PATH}"
    end
  end
end