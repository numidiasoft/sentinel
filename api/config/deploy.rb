# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'sentinel'
set :repo_url, 'git@github.com:tigerlily/sentinel.git'


# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for keep_releases is 5
set :keep_releases, 3

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

end
