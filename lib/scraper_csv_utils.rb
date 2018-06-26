# frozen_string_literal: true

###
# CSV Utility methods.
module ScraperCsvUtils
  module_function

  def export_to_csv(name, data)
    file_name = output_csv_filename(name)
    save_to_file(file_name, data)
    csv_file_saved?(file_name)
  rescue StandardError => error
    warn "  -- Error during saving to CSV file: #{error.inspect} --"
  end

  private

  ##
  # @param file_name [String] relative path to file
  # @param data [Array] of [Hash] => [{key1: 1}, {key2: 2}]
  def save_to_file(file_name, data)
    CSV.open(file_name, 'w') do |csv|
      csv << data.first.keys
      data.each { |record| csv << record.values }
    end
  end

  def output_csv_filename(file_name)
    file_name = file_name.downcase.tr(' ', '_')
    $stdout.puts "\n== Exporting `#{file_name}` ->> CSV file =="
    "output/#{file_name}.csv"
  end

  ##
  # To ensure that actual data after scraping saved.
  def csv_file_saved?(file_name)
    return unless File.exist?(file_name) && File.size?(file_name)
    $stdout.puts "  -> File `#{file_name}` successfully saved :D --"
  end
end
