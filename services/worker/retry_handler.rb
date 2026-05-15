require_relative "../../lib/app_logger"

module Services
  module Worker
    class RetryHandler

          if attempt <= MAX_RETRIES
            delay = BACKOFF_BASE**attempt
            AppLogger.warn("Retry attempt #{attempt}/#{MAX_RETRIES} for job #{job_id} (waiting #{delay}s): #{e.message}")
            sleep(delay)
            retry
          else
            AppLogger.error("Job #{job_id} failed permanently after #{MAX_RETRIES} retries: #{e.message}")
            mark_failed(job_id, e)
          end
        end
      def retries_remaining(job_id)
        used = @retry_counts[job_id] || 0
        remaining = MAX_RETRIES - used
        AppLogger.info("Job #{job_id}: #{remaining} retries remaining")
        remaining
      end

      private

      def mark_failed(job_id, error)
        AppLogger.error("Marking job #{job_id} as permanently failed: #{error.class} - #{error.message}")
        @retry_counts.delete(job_id)
      end
    end
