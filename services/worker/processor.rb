require_relative "../../lib/app_logger"

module Services
  module Worker
    class Processor
      def initialize(queue_name)
        @queue_name = queue_name
        @running = false
      end

      def start
        AppLogger.info "Starting worker for queue: #{@queue_name}"
        @running = true
        poll
      end

      def stop
        AppLogger.info "Shutting down worker for queue: #{@queue_name}"
        @running = false
      end

      def process(job)
        AppLogger.info "Processing job: #{job[:id]} (type: #{job[:type]})"
        result = execute(job)
        AppLogger.info "Job #{job[:id]} completed with status: #{result[:status]}"
        result
      end

      private

      def poll
        while @running
          AppLogger.debug "Polling queue #{@queue_name} for jobs..."
          jobs = fetch_jobs
          jobs.each { |job| process(job) }
          sleep 5
        end
      end

      def fetch_jobs
        AppLogger.debug "Fetching jobs from #{@queue_name}..."
        []
      end

      def execute(job)
        AppLogger.debug "Executing job #{job[:id]}..."
        case job[:type]
        when "email"
          AppLogger.debug "Processing email job..."
          { status: "done" }
        when "report"
          AppLogger.debug "Processing report job..."
          { status: "done" }
        else
          AppLogger.warn "Unknown job type: #{job[:type]}"
          { status: "skipped" }
        end
      end
    end
  end
end
