require 'json'

module ActiveETL
  module Steps
    module Parsers
      class Json < ActiveETL::Steps::Base

        def process
          raise_no_data_pass if result.nil?

          case result.type
            when ActiveETL::Result::TYPE_ARRAY
              raise ArgumentError, 'No header specified to convert array to json' if result.meta[:headers].nil?

              temp_data = []
              result.data.each do |array|
                temp_data << result.meta[:headers].map.with_index {|h, i| [h, array[i]]}.to_h
              end
              result.data = temp_data.to_json
              result.type = ActiveETL::Result::TYPE_JSON
            when ActiveETL::Result::TYPE_HASH
              result.data = result.data.to_json
              result.type = ActiveETL::Result::TYPE_JSON
            else
              raise_not_supported_result
          end
          self
        end
      end
    end
  end
end