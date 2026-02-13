require_relative "../../lib/app_logger"

module Services
  module Scheduler
    class Cron
      def initialize
        @jobs = {}
        @running = false
      end

      def register(name, schedule, &block)
        AppLogger.info "Registering scheduled task: #{name} (#{schedule})"
        @jobs[name] = { schedule: schedule, handler: block, last_run: nil }
      end

      def start
        AppLogger.info "Starting scheduler with #{@jobs.size} registered tasks..."
        @running = true
        run_loop
      end

      def stop
        AppLogger.info "Stopping scheduler..."
        @running = false
      end

      def run_now(name)
        job = @jobs[name]
        unless job
          AppLogger.warn "Unknown task: #{name}"
          return
        end

        AppLogger.info "Running scheduled task: #{name}"
        begin
          job[:handler].call
          job[:last_run] = Time.now
          AppLogger.info "Task #{name} completed at #{job[:last_run]}"
        rescue StandardError => e
          AppLogger.error "Task #{name} failed: #{e.message}"
        end
      end

      private

      def run_loop
        while @running
          @jobs.each do |name, job|
            if should_run?(job)
              AppLogger.info "Running scheduled task: #{name}"
              run_now(name)
            end
          end
          sleep 60
        end
      end

      def should_run?(job)
        return true if job[:last_run].nil?
        (Time.now - job[:last_run]) >= parse_interval(job[:schedule])
      end

      def parse_interval(schedule)
        case schedule
        when "every_minute" then 60
        when "every_hour" then 3600
        when "daily" then 86_400
        else 3600
        end
      end
    end
  end
end
