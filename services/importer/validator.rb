require_relative "../../lib/app_logger"

module Services
  module Importer
    class Validator

        if @errors.any?
          @errors.each do |error|
            AppLogger.error("Validation error: #{error}")
          end
          { valid: false, errors: @errors }
        else
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
