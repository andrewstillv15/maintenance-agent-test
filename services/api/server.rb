module Services
  module Api
    class Server
      def initialize(port: 3000)
        @port = port
      end

      def start
        puts "Starting API server on port #{@port}..."
        setup_routes
        puts "API server is ready and listening"
      end

      def handle_request(method, path)
        puts "Request received: #{method.upcase} #{path}"
        response = route(method, path)
        puts "Response sent: #{response[:status]}"
        response
      end

      private

      def setup_routes
        puts "Loading routes..."
        @routes = {
          "GET /health" => -> { { status: 200, body: "ok" } },
          "GET /users" => -> { { status: 200, body: fetch_users } },
          "POST /users" => -> { { status: 201, body: "created" } }
        }
        puts "#{@routes.size} routes loaded"
      end

      def route(method, path)
        key = "#{method.upcase} #{path}"
        handler = @routes[key]
        if handler
          handler.call
        else
          puts "No route found for #{key}"
          { status: 404, body: "not found" }
        end
      end

      def fetch_users
        puts "Fetching users from database..."
        []
      end
    end
  end
end
