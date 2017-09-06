module ActiveETL
  class Context
    attr_accessor :steps, :etl_file, :start_step, :hops, :params

    def initialize(etl_file, params)
      @etl_file = etl_file
      @steps = []
      @hops = {}
      @start_step = nil
      @params = params
    end
  end
end