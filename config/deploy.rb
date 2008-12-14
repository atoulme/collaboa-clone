#Adapt to your own needs as you see fit.

set :application, "forge"
set :repository, ""

set :branch, "master"
set :remote, "master"

set :use_sudo, true
set :sudo, true
set :runner, "www-data"
set :admin_runner, "www-data"
set :user, "atoulme"
# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www/#{application}"
# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git
set :scm_verbose, true
set :stages, %w(staging production testing)
require 'capistrano/ext/multistage'
