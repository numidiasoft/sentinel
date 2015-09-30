# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

set :output, './cron.log'

require_relative 'application'

every 1.minutes do
  command "RACK_ENV=#{ENV['RACK_ENV']} cd /app && bundle exec ruby ./script/check_statues.rb"
end

every 1.day do
  command "RACK_ENV=#{ENV['RACK_ENV']} cd /app && bundle exec ruby ./script/cleaner.rb"
end

