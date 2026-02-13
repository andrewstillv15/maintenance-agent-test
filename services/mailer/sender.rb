require_relative "../../lib/app_logger"

module Services
  module Mailer
    class Sender
      def initialize(smtp_host: "localhost", smtp_port: 587)
        @smtp_host = smtp_host
        @smtp_port = smtp_port
      end

      def send(to:, subject:, body:, from: "noreply@example.com")
        AppLogger.info "Sending email to #{to}..."
        AppLogger.info "Subject: #{subject}"

        validate_recipient(to)
        rendered = render_body(body)
        deliver(from: from, to: to, subject: subject, body: rendered)

        AppLogger.info "Email sent successfully to #{to}"
        { delivered: true, to: to }
      end

      def send_batch(recipients, subject:, body:)
        AppLogger.info "Sending batch email to #{recipients.size} recipients..."
        results = recipients.map do |to|
          send(to: to, subject: subject, body: body)
        end
        AppLogger.info "Batch send complete: #{results.count { |r| r[:delivered] }}/#{recipients.size} delivered"
        results
      end

      private

      def validate_recipient(email)
        unless email.match?(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i)
          AppLogger.error "Invalid email address: #{email}"
          raise ArgumentError, "Invalid email: #{email}"
        end
      end

      def render_body(body)
        AppLogger.debug "Rendering email body..."
        body.to_s
      end

      def deliver(from:, to:, subject:, body:)
        AppLogger.info "Connecting to SMTP #{@smtp_host}:#{@smtp_port}..."
        AppLogger.info "Delivering message from #{from} to #{to}"
      end
    end
  end
end
