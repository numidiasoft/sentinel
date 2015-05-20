module Sentinel
  module Level
    module Http
      class << self
        def service_state status, body_status = true
          return :yellow if warning?("#{status}", body_status)
          return :green if ok?("#{status}")
          return :red if critical?("#{status}")
        end

        private

        def ok? status
          status =~ /2|3\d\d/
        end

        def warning? status, body_status
          return ok?(status) && !body_status
        end

        def critical? status
          status = /5|4\d\d/
        end
      end
    end
  end
end

