Capistrano::Configuration.instance(:true).load do

	require "capistrano-voupe/base"
	require "capistrano-voupe/check"
	require "capistrano-voupe/nginx"
	require "capistrano-voupe/unicorn"
	require "capistrano-voupe/maintenance"
	require "capistrano-voupe/mysql"
    
    # only if the dashboard_site_uuid is present
    unless fetch(:dashboard_site_uuid, nil) == nil
	    require "capistrano-voupe/log_deployment"
    end

	default_run_options[:pty] = true
	ssh_options[:forward_agent] = true

	set :scm, "git"

	set :user, fetch(:user, nil) || "deploy"
	set :deploy_via, :remote_cache
	set :use_sudo, false
	set :keep_releases, 5

	# stops the public/images, etc not found errors
	set :normalize_asset_timestamps, false
	
	## deploying to production is the default
	set :rails_env, fetch(:rails_env, nil) || "production"
	set :environment, fetch(:environment, nil) || "production"
	set :deploy_to, fetch(:deploy_to, nil) || "/opt/apps/#{application}"


	## ==================================================================
	## init
	## ==================================================================
	desc 'Restart the whole remote application'
	task :restart, :roles => :web do
		unicorn.restart
	end

	desc 'Stop the whole remote application'
	task :stop, :roles => :web do
		unicorn.stop
	end

	desc 'Start the whole remote application'
	task :start, :roles => :web do
		unicorn.start
	end
	
end