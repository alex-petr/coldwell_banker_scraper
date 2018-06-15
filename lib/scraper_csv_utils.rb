# frozen_string_literal: true

###
# CSV Utility methods.
module ScraperCsvUtils
  module_function

  def export_to_csv(name, data)
    file_name = output_csv_filename(name)

    # To get actual data after scraping.
    remove_existing_file(file_name)

    CSV.open(file_name, 'w') do |csv|
      csv << data.first.keys
      data.each { |record| csv << record.each_value }
    end

    csv_file_created?(file_name)
  rescue StandardError => error
    warn '  -- Error during saving to CSV file --'
    warn error.inspect
  end

  def output_csv_filename(file_name)
    file_name = file_name.downcase.tr(' ', '_')
    $stdout.puts "\n== Exporting `#{file_name}` ->> CSV file =="
    "output/#{file_name}.csv"
  end

  def remove_existing_file(file_name)
    File.delete(file_name) if File.exist?(file_name)
  end

  def csv_file_created?(file_name)
    return unless File.exist?(file_name)
    $stdout.puts "  -> File `#{file_name}` successfully created :D --"
  end
end
