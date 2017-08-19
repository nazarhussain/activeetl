module ActiveETL
  # class to do pre-processing on etl file
  # like removing space or new line characters
  # this parser will make future safe to fix any file encoding issue
  class Parser
    class << self
      def parse(source_file, &block)

        context = ActiveETL::Context.new(source_file)
        dsl = ActiveETL::DSL.new(context)

        if source_file
          dsl.instance_eval(File.read(source_file), source_file)
        else
          dsl.instance_eval(&block)
        end
        context
      end
    end
  end
end