require 'benchmark'

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
      log "Starting #{@context.etl_file}"

      time = Benchmark.realtime do
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
          log " == Processing '#{step.name}'"
          time = Benchmark.realtime do
            result = step.process.result
          end
          log " == Finished '#{step.name}' #{time * 1000}ms"

          # Move to next step and store current as previous
          previous_index = current_index
          current_index = @context.hops[current_index]
        end
      end
      log "Finished #{@context.etl_file} #{time * 1000}ms"
    end

    def log(content)
      ActiveETL.logger.tagged(@context.etl_file) {ActiveETL.logger.info(content)}
    end
  end
end