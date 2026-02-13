require_relative "../../lib/app_logger"

module Services
  module Importer
    class Validator
      REQUIRED_FIELDS = %w[id name email].freeze

      def initialize(rules: {})
        @rules = rules
        @errors = []
      end

      def validate(row)
        @errors = []
        check_required_fields(row)
        check_email_format(row)
        check_custom_rules(row)

        if @errors.any?
          @errors.each do |error|
            AppLogger.error("Validation error: #{error}")
          end
          { valid: false, errors: @errors }
        else
          { valid: true, errors: [] }
        end
      end

      def validate_batch(rows)
        results = rows.each_with_index.map do |row, index|
          result = validate(row)
          unless result[:valid]
            AppLogger.error("Validation error: row #{index + 1} has #{result[:errors].size} error(s)")
          end
          result.merge(row_index: index + 1)
        end

        invalid_count = results.count { |r| !r[:valid] }
        if invalid_count > 0
          AppLogger.error("Validation error: #{invalid_count}/#{rows.size} rows failed validation")
        end

        results
      end

      private

      def check_required_fields(row)
        REQUIRED_FIELDS.each do |field|
          if row[field].nil? || row[field].to_s.strip.empty?
            @errors << "Missing required field: #{field}"
          end
        end
      end

      def check_email_format(row)
        email = row["email"]
        return if email.nil?

        unless email.match?(/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i)
          @errors << "Invalid email format: #{email}"
        end
      end

      def check_custom_rules(row)
        @rules.each do |field, rule|
          value = row[field.to_s]
          unless rule.call(value)
            @errors << "Custom validation failed for field: #{field}"
          end
        end
      end
    end
  end
end
