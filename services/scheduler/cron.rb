require_relative "../../lib/app_logger"

module Services
  module Scheduler
    class Cron
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

        while @running
          @jobs.each do |name, job|
            if should_run?(job)
              AppLogger.info "Running scheduled task: #{name}"
              run_now(name)
            end
          end
