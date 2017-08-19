module ActiveETL

  # This class will be responsible to process one ETL job
  # So multiple instances will in memory to execute multiple ETL jobs
  class Process
    attr_reader :context

    def initialize(context)
      raise ArgumentError, ':context must be ActiveETL::Context object' unless context.is_a? ActiveETL::Context

      @context = context
    end

    def start
      puts "Processing #{@context.etl_file}"
      puts @context.inspect
    end
  end
end