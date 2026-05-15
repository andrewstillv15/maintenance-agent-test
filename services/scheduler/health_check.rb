require "logger"
require "net/http"

module Services
  module Scheduler
    class HealthCheck
      def initialize(services: [])
        @services = services
        @logger = Logger.new(STDOUT)
      end

      def check_all
        puts "Running health checks for #{@services.size} services..."
        results = @services.map { |service| check(service) }

        healthy = results.count { |r| r[:healthy] }
        puts "Health check summary: #{healthy}/#{@services.size} services healthy"

        @logger.info("Health check complete: #{healthy}/#{@services.size} healthy")
        results
      end

      def check(service)
        puts "Checking health of #{service[:name]}..."
        start = Time.now
        status = ping(service[:url])
        duration = ((Time.now - start) * 1000).round(2)

        if status == 200
          puts "#{service[:name]} is healthy (#{duration}ms)"
          @logger.info("#{service[:name]} healthy - #{duration}ms")
          { name: service[:name], healthy: true, response_time: duration }
        else
          puts "#{service[:name]} is unhealthy (status: #{status})"
          @logger.info("#{service[:name]} unhealthy - status #{status}")
          { name: service[:name], healthy: false, status: status }
        end
      rescue StandardError => e
        puts "#{service[:name]} health check failed: #{e.message}"
        @logger.info("#{service[:name]} check error: #{e.message}")
        { name: service[:name], healthy: false, error: e.message }
      end

      private

      def ping(url)
        uri = URI(url)
        response = Net::HTTP.get_response(uri)
        response.code.to_i
      end
    end
  end
end
