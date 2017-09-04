require 'active_record'
require 'activerecord-import'

module ActiveETL
  module Steps
    module Stores

      ##
      # Class to store to a database
      #
      # === Options
      # * +:target:+    - Database connection target
      # * +:table:+     - Table to store data
      class Database < ActiveETL::Steps::Base

        def process
          raise ArgumentError, 'Must provide a database connection target' if options[:target].nil?
          raise ArgumentError, 'Must provide a database table' if options[:table].nil?

          # Create a dummy model to start import
          # TODO: Fix this hack for a better workaround
          # To pass table name to model
          ENV['dummy_model_class_tbl_name'] = options[:table].to_s
          dummy_model_class = Class.new(::ActiveRecord::Base) do
            self.table_name = ENV['dummy_model_class_tbl_name']

            def self.name
              'DummyModel'
            end
          end

          # Establish database connection
          dummy_model_class.establish_connection connection.spec.config

          case result.type
            when ActiveETL::Result::TYPE_ARRAY
              data = dummy_model_class.import result.meta[:headers], result.data

              result.data = data.ids
              result.meta = {
                  num_inserts: data.num_inserts,
                  failed_instances: data.failed_instances
              }
            else
              raise_not_supported_result_type result.type
          end

          self
        end

        def default_options
          {target: nil, table: nil}
        end

        private
        def connection
          @conn ||= begin
            ActiveETL::Engine.connection(options[:target])
          end
        end
      end
    end
  end
end
