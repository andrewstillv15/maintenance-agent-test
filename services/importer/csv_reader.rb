require "csv"
require_relative "../../lib/app_logger"

module Services
  module Importer
    class CsvReader
      def initialize(file_path)
        @file_path = file_path
      end

      def read
        AppLogger.info "Opening CSV file: #{@file_path}"
        unless File.exist?(@file_path)
          AppLogger.error "File not found: #{@file_path}"
          raise "CSV file not found: #{@file_path}"
        end

        rows = []
        CSV.foreach(@file_path, headers: true).with_index(1) do |row, index|
          AppLogger.debug "Importing row #{index}: #{row.to_h}"
          rows << row.to_h
        end

        AppLogger.info "Import complete: #{rows.size} rows imported from #{@file_path}"
        rows
      end

      def read_in_batches(batch_size: 100)
        AppLogger.info "Reading CSV in batches of #{batch_size}..."
        batch = []
        total = 0

        CSV.foreach(@file_path, headers: true) do |row|
          batch << row.to_h
          if batch.size >= batch_size
            total += batch.size
            AppLogger.info "Importing row batch (#{total} rows processed so far)..."
            yield batch
            batch = []
          end
        end

        unless batch.empty?
          total += batch.size
          AppLogger.info "Importing row #{total} (final batch)..."
          yield batch
        end

        AppLogger.info "Batch import complete: #{total} total rows"
        total
      end
    end
  end
end
