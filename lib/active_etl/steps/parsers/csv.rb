require 'tempfile'

module ActiveETL
  module Steps
    module Parsers

      ##
      # Class to parse and convert text based stream to a CSV table
      #
      # ==== Options
      # * +:headers+    - Does CSV contains headers, default is true
      # * +:columns+    - Array of columns to extract from CSV
      # * +:encoding+   - CSV File encoding
      # @note headers will be converted to lowercase and symbols.
      # @note Don't use *-* symbols in headers
      class Csv < ActiveETL::Steps::Base

        def process
          raise_no_data_pass if result.nil?
          raise_not_supported_result_type unless result.type == ActiveETL::Result::TYPE_BINARY
          raise ArgumentError, 'CSV headers must be read from file or specify by user' unless options[:headers] == true or options[:headers].is_a? Array

          headers_in_stream = options[:headers] && !options[:headers].is_a?(Array)

          file = Tempfile.new("#{@name}-#{Time.now}")
          unless headers_in_stream
            file.write(options[:headers].map{|h| h.to_s}.join(','))
            file.write("\n")
          end
          file.write @result.data
          file.rewind

          csv = ActiveETL::Utilities.table_for_csv_with_headers(file,
                                                                encoding: options[:encoding])
          file.close
          file.unlink

          # If user specify to limit the columns
          if options[:columns]
            csv.by_col!
            (csv.headers - options[:columns]).map {|col| csv.delete(col)}
            csv.by_row!
          end

          @result = ActiveETL::Result.new(csv, ActiveETL::Result::TYPE_TABLE, {headers: csv.headers})
          self
        end

        def default_options
          {headers: true, encoding: 'ISO-8859-1', columns: nil}
        end
      end
    end
  end
end