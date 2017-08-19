module ActiveETL
  # This class will hold base level details of over all ETL execution
  class Engine
    class << self

      def init(options={})
        return unless @initialized

        options[:config] ||= 'database.yml'
        options[:config] = 'config/database.yml' unless File.exist?(options[:config])
        database_configuration = YAML::load(ERB.new(IO.read(options[:config])).result + "\n")
        @initialized = true
      end

      def process(file)
        ActiveETL::Process.new(parse(file)).start
      end

      def parse(file)
        ActiveETL::Parser.parse(file)
      end
    end # class << self
  end
end