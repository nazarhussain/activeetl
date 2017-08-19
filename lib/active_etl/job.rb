module ActiveETL

  # This class will be responsible to process one ETL job
  # So multiple instances will in memory to execute multiple ETL jobs
  class Job
    attr_reader :context

    def initialize(context)
      raise ArgumentError, ':context must be ActiveETL::Context object' unless context.is_a? ActiveETL::Context

      @context = context
    end

    def start
      puts "Processing #{@context.etl_file}"
      current_index = @context.start_step
      previous_index = nil
      result = nil

      while !current_index.nil?
        # Load current step
        step = @context.steps[current_index]

        # Set result from previous step
        # If some previous step present
        step.result = result if previous_index.present?

        # Process the current step
        puts "Processing '#{step.name}'"
        result = step.process.result

        # Move to next step and store current as previous
        previous_index  = current_index
        current_index = @context.hops[current_index]
      end
      #puts @context.inspect
    end
  end
end