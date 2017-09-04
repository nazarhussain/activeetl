require 'optparse'

require_relative '../../lib/active_etl'

module ActiveETL
  class Cli
    def self.run(args)
      options = {}
      OptionParser.new do |opts|
        opts.banner = 'Usage: activeetl your-script.rb [options]'

        opts.on('-d', '--database [DB_CONFIG_FILE]', 'Specify a database config class') do |db|
          options[:db_config] = db
        end

      end.parse!(args)

      if args.size < 1
        puts 'Usage: activeetl your-script.etl second-script.etl'
        exit(-1)
      end

      ActiveETL::Engine.init(options)
      ARGV.each do |file|
        ActiveETL::Engine.process(file) #if File.exist? file
      end
    end
  end
end
