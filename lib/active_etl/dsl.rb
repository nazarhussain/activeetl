module ActiveETL
  class DSL
    attr_accessor :params

    def initialize(context, params)
      @context = context
      @params = params
    end

    def step(name, step_klass, params={})
      raise ArgumentError, 'Must provide step name' if name.nil?

      step_klass = "ActiveETL::Steps::#{step_klass.to_s.classify}" if step_klass.is_a? Symbol or step_klass.is_a? String
      begin
        step_klass = step_klass.constantize
      rescue
        raise ArgumentError, "We cant found step definition for #{step_klass}"
      end
      step_instance = step_klass.new(name, params)
      @context.steps << step_instance

      step_instance
    end

    # Bind step flow
    # Can be provided two or multiple steps
    # Order will be followed
    def bind(*steps)
      raise ArgumentError, 'At least provide two arguments' if steps.size < 2

      @context.start_step = @context.steps.index(steps[0]) if @context.start_step == nil

      0.upto(steps.size - 2) do |i|
        first_index = @context.steps.index(steps[i])
        second_index = @context.steps.index(steps[i+1])

        @context.hops[first_index] = second_index
      end
    end
  end
end