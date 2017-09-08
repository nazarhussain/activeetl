module ActiveETL

  # A class to store result of any step execution
  class Result
    # Of type CSV::Table to handle CSV type data result
    TYPE_TABLE    = 'table'.freeze

    # To store any kind of hash or json structure
    TYPE_HASH     = 'hash'.freeze

    # To store binary or text based data
    TYPE_BINARY   = 'binary'.freeze

    # List of all available result types
    TYPES = [TYPE_TABLE, TYPE_HASH, TYPE_BINARY]

    # @return [Hash] Set of options passed to step during ETL process
    attr_accessor :meta

    # @return [Class] Based on type of the result data can be either table, hash or string
    attr_accessor :data

    # @return [String] Any of types included in *TYPES*
    # @see TYPES
    attr_accessor :type

    def initialize(data, type, meta={})
      raise ArgumentError, "Type must be nay of #{TYPES.to_s}" unless TYPES.include? type

      @data = data
      @meta = meta
      @type = type
    end
  end
end
