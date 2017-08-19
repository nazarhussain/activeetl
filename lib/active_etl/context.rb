module ActiveETL
  class Context
    attr_accessor :steps, :etl_file, :start_step, :hops

    def initialize(etl_file)
      @etl_file = etl_file
      @steps = []
      @hops = {}
      @start_step = nil
    end
  end
end