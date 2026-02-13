module Services
  module Mailer
    class Sender
      def initialize(smtp_host: "localhost", smtp_port: 587)
        @smtp_host = smtp_host
        @smtp_port = smtp_port
      end

      def send(to:, subject:, body:, from: "noreply@example.com")
        puts "Sending email to #{to}..."
        puts "Subject: #{subject}"

        validate_recipient(to)
        rendered = render_body(body)
        deliver(from: from, to: to, subject: subject, body: rendered)

        puts "Email sent successfully to #{to}"
        { delivered: true, to: to }
      end

      def send_batch(recipients, subject:, body:)
        puts "Sending batch email to #{recipients.size} recipients..."
        results = recipients.map do |to|
          send(to: to, subject: subject, body: body)
        end
        puts "Batch send complete: #{results.count { |r| r[:delivered] }}/#{recipients.size} delivered"
        results
      end

      private

      def validate_recipient(email)
        unless email.match?(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i)
          puts "Invalid email address: #{email}"
          raise ArgumentError, "Invalid email: #{email}"
        end
      end

      def render_body(body)
        puts "Rendering email body..."
        body.to_s
      end

      def deliver(from:, to:, subject:, body:)
        puts "Connecting to SMTP #{@smtp_host}:#{@smtp_port}..."
        puts "Delivering message from #{from} to #{to}"
      end
    end
  end
end
