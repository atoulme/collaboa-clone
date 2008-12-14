set :db_name, "forge_test"
set :db_user, "forge"
set :db_passwd, "forge"

set :branch, "dev"
set :rails_env, "test"

role :app, "localhost"
role :web, "localhost"
role :db,  "localhost", :primary => true
