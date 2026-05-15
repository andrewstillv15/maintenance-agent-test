require_relative "../../lib/app_logger"

module Services
  module Api
    class Server
      end

      def start
        AppLogger.info "Starting API server on port #{@port}..."
        setup_routes
        AppLogger.info "API server is ready and listening"
      end

      def handle_request(method, path)
        AppLogger.info "Request received: #{method.upcase} #{path}"
        response = route(method, path)
        AppLogger.info "Response sent: #{response[:status]}"
        response
      end

      private

      def setup_routes
        AppLogger.info "Loading routes..."
        @routes = {
          "GET /health" => -> { { status: 200, body: "ok" } },
          "GET /users" => -> { { status: 200, body: fetch_users } },
          "POST /users" => -> { { status: 201, body: "created" } }
        }
        AppLogger.info "#{@routes.size} routes loaded"
      end

      def route(method, path)
        if handler
          handler.call
        else
          AppLogger.info "No route found for #{key}"
          { status: 404, body: "not found" }
        end
      end

      def fetch_users
        AppLogger.info "Fetching users from database..."
        []
      end
    end
