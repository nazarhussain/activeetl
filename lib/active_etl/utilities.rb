require 'csv'

module ActiveETL
  class Utilities
    class << self
      def table_for_csv_with_headers(file_stream_io, options)
        CSV.table(file_stream_io,
                  encoding: options[:encoding],
                  headers: true)
      end

      def table_for_csv_custom_headers(file_stream_io, options)
        csv = CSV.open(file_stream_io,
                       encoding: options[:encoding],
                       headers: false,
                       converters: :numeric)

        first_row = csv.readline
        header_with_row = CSV::Row.new(options[:headers], first_row)
        table = CSV::Table.new([header_with_row])

        csv.each do |row|
          table << row
        end

        table
      end
    end
  end
end