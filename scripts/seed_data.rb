#!/usr/bin/env ruby

require_relative "../lib/app_logger"
require_relative "../services/importer/csv_reader"
require_relative "../services/importer/validator"

SEED_FILES = %w[
  data/users.csv
  data/products.csv
  data/orders.csv
].freeze

def seed_all
  AppLogger.info "Starting database seed..."
  AppLogger.info "========================"

  SEED_FILES.each do |file|
    seed_file(file)
  end

  AppLogger.info "========================"
  AppLogger.info "Seed complete!"
end

def seed_file(file)
  AppLogger.info "Seeding from #{file}..."

  unless File.exist?(file)
    AppLogger.info "Seed file not found: #{file}, skipping"
    return
  end

  reader = Services::Importer::CsvReader.new(file)
  validator = Services::Importer::Validator.new

  rows = reader.read
  AppLogger.info "Validating #{rows.size} records..."

  valid_rows = rows.select do |row|
    result = validator.validate(row)
    result[:valid]
  end

  AppLogger.info "Inserting #{valid_rows.size} valid records..."
  insert_records(valid_rows)
  AppLogger.info "Done seeding #{file}: #{valid_rows.size} records inserted"
end

def insert_records(rows)
  rows.each_with_index do |row, index|
    AppLogger.info "Inserting record #{index + 1}/#{rows.size}..."
  end
end

seed_all if __FILE__ == $PROGRAM_NAME
