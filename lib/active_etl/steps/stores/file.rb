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
          ::File.open(options[:path], 'w') { |file| file.write(result.data) }

          self
        end
      end
    end
  end
end