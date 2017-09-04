# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_etl/version'

Gem::Specification.new do |spec|
  spec.name          = 'activeetl'
  spec.version       = ActiveETL::VERSION
  spec.authors       = ['Nazar Hussain']
  spec.email         = ['nazarhussain@gmail.com']

  spec.summary       = %q{A new generation of production ready ETL in Ruby.}
  spec.description   = %q{A new generation of production ready ETL in Ruby.}
  spec.homepage      = 'http://basicdrift.com'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'bin'
  spec.executables   = ['activeetl']
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '>= 5.1.3'
  spec.add_dependency 'activerecord', '>= 5.1.3'
  spec.add_dependency 'activerecord-import', '~> 0.19.1'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
