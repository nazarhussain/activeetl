module ActiveETL
  module Steps

    # Base class for all steps to in pipeline
    class Base
      attr_accessor :name, :options, :result

      def initialize(name, options={}, result=nil)
        @name = name
        @options = options
        @result = result

        @options = default_options.merge(@options) if self.respond_to? :default_options
      end

      def process
        raise StandardError, "You did not implemented process method in your class #{self.class}."
      end

      private

      def default_options
        raise ArgumentError, "Implement default options for for #{self.class}"
      end

      def raise_not_supported_result_type(type)
        raise ArgumentError, "Result type #{type} is not supported by #{self.class}"
      end

      def raise_no_data_pass
        raise ArgumentError, "No data passed from previous step in #{self.class}"
      end
    end
  end
end