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
      #
      #
      class Csv < ActiveETL::Steps::Base

        def process
          file = ::CSV.open(options[:path], {encoding: options[:encoding]})

          headers  = file.readline if options[:headers]

          if options[:headers] and options[:columns]
            column_indexes = options[:columns].map{ |c| headers.index(c)}
            headers = options[:columns]
            data = []
            file.each do |row|
              data << row.map.with_index{|v, i| v if column_indexes.include?(i)}.compact
            end

            @result = ActiveETL::Result.new(data, {headers: headers})
          else
            @result = ActiveETL::Result.new(file.readlines, {headers: headers})
          end
          @result.type = ActiveETL::Result::TYPE_ARRAY
          self
        end

        def default_options
          {headers: true, encoding: 'ISO-8859-1', columns: nil}
        end
      end
    end
  end
end

