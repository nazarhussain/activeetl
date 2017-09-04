require 'active_support/logger'

module ActiveETL
  module Logger
    def self.included(klass)
      klass.extend ClassMethods
    end

    module ClassMethods
      def logger
        @log ||= ::ActiveSupport::TaggedLogging.new(::Logger.new(STDOUT))
      end
    end
  end
end