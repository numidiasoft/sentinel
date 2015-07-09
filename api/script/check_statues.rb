require_relative '../config/application'
require 'colorize'

module Sentinel
  statuses = Sentinel::HealthCheck.check_all
  statuses = statuses.map do |item|
    { status: item[:status] }
  end

  grouped_by_statuses =  statuses.group_by { |h| h[:status] }

  groups = grouped_by_statuses.keys

  groups.each do |group|
    puts "\n"
    puts "[#{Time.now}] -- You have #{grouped_by_statuses[group].size} service(s) in #{group} state".send(group.to_sym)
  end
end
