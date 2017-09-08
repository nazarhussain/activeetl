require 'csv'

module ActiveETL
  module Steps
    module Stores
      ##
      # Class to read the CSV File
      # ==== Options
      # * +:path+       - Path to a CSV File
      #
      #
      class File < ActiveETL::Steps::Base

        def process
          raise_no_data_pass if result.nil?

          case result.type
            when ActiveETL::Result::TYPE_STRING
            when ActiveETL::Result::TYPE_JSON
              ::File.open(options[:path], 'w') { |file| file.write(result.data) }
            when ActiveETL::Result::TYPE_ARRAY
              CSV.open(options[:path], 'wb') do |csv|
                csv << result.meta[:headers]
                result.data.each do |row|
                  csv << row
                end
              end
          end

          self
        end
      end
    end
  end
end