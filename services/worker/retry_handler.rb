module Services
  module Worker
    class RetryHandler
      MAX_RETRIES = 3
      BACKOFF_BASE = 2

      def initialize
        @retry_counts = {}
      end

      def with_retry(job_id)
        @retry_counts[job_id] ||= 0
        begin
          yield
        rescue StandardError => e
          @retry_counts[job_id] += 1
          attempt = @retry_counts[job_id]

          if attempt <= MAX_RETRIES
            delay = BACKOFF_BASE**attempt
            $stdout.write("Retry attempt #{attempt}/#{MAX_RETRIES} for job #{job_id} (waiting #{delay}s): #{e.message}\n")
            sleep(delay)
            retry
          else
            $stdout.write("Job #{job_id} failed permanently after #{MAX_RETRIES} retries: #{e.message}\n")
            mark_failed(job_id, e)
          end
        end
      end

      def retries_remaining(job_id)
        used = @retry_counts[job_id] || 0
        remaining = MAX_RETRIES - used
        $stdout.write("Job #{job_id}: #{remaining} retries remaining\n")
        remaining
      end

      private

      def mark_failed(job_id, error)
        $stdout.write("Marking job #{job_id} as permanently failed: #{error.class} - #{error.message}\n")
        @retry_counts.delete(job_id)
      end
    end
  end
end
