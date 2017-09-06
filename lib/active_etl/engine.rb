require 'yaml'
require 'erb'

module ActiveETL
  # This class will hold base level details of over all ETL execution
  class Engine
    cattr_reader :initialized, :databases, :params

    class << self

      def init(options={})
        return if @@initialized == true

        @@params  = options[:params] || {}
        @@params  = parse_params(@@params) if @@params.is_a? String


        options[:db_config] ||= 'config/database.yml'
        @@databases = YAML::load(ERB.new(IO.read(options[:db_config])).result + "\n") if File.exist? options[:db_config]

        @@initialized = true
      end

      def process(files=[])
        files = [files] unless files.is_a? Array

        files.each do |file|
          #Process.fork do
            ActiveETL::Job.new(parse(file)).start
          #end
        end

        #Process.wait
      end

      def parse(file)
        ActiveETL::Parser.parse(file, @@params)
      end

      def connection(identifier)
        ActiveRecord::Base.establish_connection(@@databases[identifier.to_s])
      end

      def parse_params(params_string)
        Hash[*params_string.split(/,/).map{|p| p.split(/=/)}.flatten]
      end
    end # class << self
  end
end