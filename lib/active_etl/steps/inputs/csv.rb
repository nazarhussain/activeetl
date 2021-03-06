require 'csv'

module ActiveETL
  module Steps
    module Inputs

      ##
      # Class to read the CSV File
      # ==== Options
      # * +:path+       - Path to a CSV File
      # * +:headers+    - Does CSV contains headers, default is true
      # * +:columns+    - Array of columns to extract from CSV
      # * +:encoding+   - CSV File encoding
      # @note headers will be converted to lowercase and symbols
      class Csv < ActiveETL::Steps::Base

        # @return [ActiveETL::Steps::Inputs::Csv]
        def process
          raise ArgumentError, 'CSV headers must be read from file or specify by user' unless options[:headers] == true or options[:headers].is_a? Array

          File.open(options[:path], 'r') do |file|

            # If header option is true and is not a user defined array
            headers_in_file = options[:headers] && !options[:headers].is_a?(Array)

            if headers_in_file
              csv = ActiveETL::Utilities.table_for_csv_with_headers(file,
                                                                    encoding: options[:encoding])
            else
              csv = ActiveETL::Utilities.table_for_csv_custom_headers(file,
                                                                      encoding: options[:encoding],
                                                                      headers: options[:headers])
            end

            # If user specify to limit the columns
            if options[:columns]
              csv.by_col!
              (csv.headers - options[:columns]).map {|col| csv.delete(col)}
              csv.by_row!
            end

            @result = ActiveETL::Result.new(csv, ActiveETL::Result::TYPE_TABLE, {headers: csv.headers})
          end
          self
        end

        def default_options
          {headers: true, encoding: 'ISO-8859-1', columns: nil}
        end
      end
    end
  end
end

