module ActiveETL
  module Steps

    # Base class for all steps to in pipeline
    class Base
      attr_accessor :name, :options

      def initialize(name, options={})
        @name = name
        @options = options
      end

      def process
        raise Error, 'Extend this class to build your own step.'
      end
    end
  end
end