require 'csv'

module ActiveETL
  module Steps
    module Parsers
      class Csv < ActiveETL::Steps::Base

        def process
          raise_no_data_pass if result.nil?

          case result.type
            when ActiveETL::Result::TYPE_STRING
              csv = ::CSV.parse(result.data, headers: options[:headers], encoding: options[:encoding])
              result.data = csv
              result.meta = {headers: csv.headers}
              result.type = ActiveETL::Result::TYPE_ARRAY
            else
              raise_not_supported_result_type result.type
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