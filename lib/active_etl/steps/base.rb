module ActiveETL
  module Steps
    # Base class for all steps to in pipeline
    class Base
      # @return [String] Name or label of the step that is passed in the ETL file
      attr_accessor :name

      # @return [Hash] Set of options passed to step during ETL process
      attr_accessor :options

      # @return [ActiveETL::Result] Instance of result class to hold any processing result during this step
      attr_accessor :result

      # Initialize the step, normally be done in a sub class
      #
      # @param name [String] Label of the step
      # @param options [Hash] Options passed to that step, look for individual step default options method for supported options
      # @param result [ActiveETL::Result] Any result on which step is dependent
      #
      def initialize(name, options={}, result=nil)
        @name = name
        @options = options
        @result = result

        @options = default_options.merge(@options) if self.respond_to? :default_options
      end

      def process
        raise StandardError, "You did not implemented process method in your class #{self.class}."
      end

      # @return [Hash] Set of default options for a specific step
      # @note Must be implemented in sub classes
      def default_options
        raise ArgumentError, "Implement default options for for #{self.class}"
      end

      private
      def raise_not_supported_result_type(type)
        raise ArgumentError, "Result type #{type} is not supported by #{self.class}"
      end

      def raise_no_data_pass
        raise ArgumentError, "No data passed from previous step in #{self.class}"
      end
    end
  end
end