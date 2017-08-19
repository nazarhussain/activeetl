module ActiveETL

  ##
  # A class to store result of any step execution
  class Result
    TYPE_ARRAY    = 'array'.freeze  # Array of array
    TYPE_HASH     = 'hash'.freeze   # Array of hash
    TYPE_STRING   = 'string'.freeze # Single string
    TYPE_JSON     = 'json'.freeze   # JSON string
    attr_accessor :meta, :data, :type

    def initialize(data=nil, meta={}, type=nil)
      @data = data
      @meta = meta
      @type = type
    end
  end
end
