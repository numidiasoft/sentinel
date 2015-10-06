module Sentinel
  module Jobs
    autoload :Checker, "./app/jobs/checker"
    autoload :Cleaner, "./app/jobs/cleaner"
    autoload :SlackNotifier, "./app/jobs/slack_notifier"
  end
end
