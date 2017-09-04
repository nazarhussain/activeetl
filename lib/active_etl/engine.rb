require 'yaml'
require 'erb'

module ActiveETL
  # This class will hold base level details of over all ETL execution
  class Engine
    cattr_reader :initialized, :databases

    class << self

      def init(options={})
        return if @@initialized == true

        options[:db_config] ||= 'config/database.yml'
        @@databases = YAML::load(ERB.new(IO.read(options[:db_config])).result + "\n")

        @@initialized = true
      end

      def process(file)
        ActiveETL::Job.new(parse(file)).start
      end

      def parse(file)
        ActiveETL::Parser.parse(file)
      end

      def connection(identifier)
        ActiveRecord::Base.establish_connection(@@databases[identifier.to_s])
      end
    end # class << self
  end
end