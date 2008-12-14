set :db_name, "www_forge"
set :db_user, "www_forge"
set :db_passwd, "secret"

set :rails_env, "production"

role :app, ""
role :web, ""
role :db,  "", :primary => true
