require "csv"

module Services
  module Importer
    class CsvReader
      def initialize(file_path)
        @file_path = file_path
      end

      def read
        puts "Opening CSV file: #{@file_path}"
        unless File.exist?(@file_path)
          puts "File not found: #{@file_path}"
          raise "CSV file not found: #{@file_path}"
        end

        rows = []
        CSV.foreach(@file_path, headers: true).with_index(1) do |row, index|
          puts "Importing row #{index}: #{row.to_h}"
          rows << row.to_h
        end

        puts "Import complete: #{rows.size} rows imported from #{@file_path}"
        rows
      end

      def read_in_batches(batch_size: 100)
        puts "Reading CSV in batches of #{batch_size}..."
        batch = []
        total = 0

        CSV.foreach(@file_path, headers: true) do |row|
          batch << row.to_h
          if batch.size >= batch_size
            total += batch.size
            puts "Importing row batch (#{total} rows processed so far)..."
            yield batch
            batch = []
          end
        end

        unless batch.empty?
          total += batch.size
          puts "Importing row #{total} (final batch)..."
          yield batch
        end

        puts "Batch import complete: #{total} total rows"
        total
      end
    end
  end
end
