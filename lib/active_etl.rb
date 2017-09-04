require 'active_support/core_ext/string/inflections'
require 'active_support/dependencies'
ActiveSupport::Dependencies.autoload_paths = [
    'lib/'
]

module ActiveETL
  include ActiveETL::Logger
end
