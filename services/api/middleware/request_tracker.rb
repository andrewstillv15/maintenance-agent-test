require "securerandom"
require_relative "../../../lib/app_logger"

module Services
  module Api
    module Middleware
      class RequestTracker
        def initialize
        end

        def track(request)
          request_id = SecureRandom.uuid
          AppLogger.info("Incoming request: #{request[:method]} #{request[:path]} [#{request_id}]")

          start_time = Time.now
          yield request_id if block_given?
          duration = ((Time.now - start_time) * 1000).round(2)

          AppLogger.info("Request completed: [#{request_id}] #{duration}ms")
          request_id
        end

        def log_error(request_id, error)
          AppLogger.error("Request failed: [#{request_id}] #{error.message}")
        end

        def log_slow_request(request_id, duration_ms)
          if duration_ms > 1000
            AppLogger.warn("Slow request detected: [#{request_id}] #{duration_ms}ms")
          end
        end
      end
