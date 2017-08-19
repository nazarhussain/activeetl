require 'optparse'

require_relative '../../lib/active_etl'

module ActiveETL
  class Cli
    def self.run(args)
      options = {}
      OptionParser.new do |opts|
        opts.banner = "Usage: kiba your-script.etl [options]"
        opts.on("-r", "--runner [RUNNER_CLASS]", "Specify Kiba runner class") do |runner|
          options[:runner] = runner
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
