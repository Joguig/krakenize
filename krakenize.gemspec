# -*- encoding: utf-8 -*-
# Add this directory to the Ruby load path.
lib_directory = File.expand_path(File.dirname(__FILE__))
unless $LOAD_PATH.include?(lib_directory)
  $LOAD_PATH.unshift(lib_directory)
end

require 'date'

# Now for the main event...
Gem::Specification.new do |s|
  s.name          = 'krakenize'
  s.version       = '0.1.0'
  s.summary       = 'Add Kraken-specific ActiveRecord methods.'
  s.platform      = Gem::Platform::RUBY
  s.date          = Date.today.strftime('%Y-%m-%d')
  s.authors       = ['Mukund Lakshman']
  s.email         = 'mukund@twitch.tv'
  s.homepage      = 'http://github.com/justintv/krakenize'

  s.require_paths = ['lib']

  s.files         = `git ls-files -- {lib,spec}/*`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")

  s.add_dependency 'rails', '>= 3.0.0'
  s.add_dependency 'activerecord', '>= 3.0.0'

  s.add_development_dependency 'rspec', '>= 2.11.0'
  s.add_development_dependency 'sqlite3', '>= 1.3.6'
end
