require "net/http"
require_relative "../../lib/app_logger"

module Services
  module Scheduler
    class HealthCheck
      def initialize(services: [])
        @services = services
      end

      def check_all
        AppLogger.info "Running health checks for #{@services.size} services..."
        results = @services.map { |service| check(service) }

        healthy = results.count { |r| r[:healthy] }
        AppLogger.info "Health check summary: #{healthy}/#{@services.size} services healthy"

        AppLogger.info("Health check complete: #{healthy}/#{@services.size} healthy")
        results
      end

      def check(service)
        AppLogger.info "Checking health of #{service[:name]}..."
        start = Time.now
        status = ping(service[:url])
        duration = ((Time.now - start) * 1000).round(2)

        if status == 200
          AppLogger.info "#{service[:name]} is healthy (#{duration}ms)"
          AppLogger.info("#{service[:name]} healthy - #{duration}ms")
          { name: service[:name], healthy: true, response_time: duration }
        else
          AppLogger.warn "#{service[:name]} is unhealthy (status: #{status})"
          AppLogger.warn("#{service[:name]} unhealthy - status #{status}")
          { name: service[:name], healthy: false, status: status }
        end
      rescue StandardError => e
        AppLogger.error "#{service[:name]} health check failed: #{e.message}"
        AppLogger.error("#{service[:name]} check error: #{e.message}")
        { name: service[:name], healthy: false, error: e.message }
      end

