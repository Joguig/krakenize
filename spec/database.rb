require 'active_record'
require 'krakenize'

# Include Cymbalize manually, since Railtie hook won't fire.
ActiveRecord::Base.send(:include, Krakenize)

# Create our database.
ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => ':memory:'
)

module Kraken
end

module TestHelper
  def create_class(name, parent = nil)
    if Object.const_defined?(name)
      return Object.const_get(name)
    end

    parent ||= ActiveRecord::Base
    klass = Class.new(parent)
    Object.const_set(name, klass)
    klass
  end

  def create_classes(*classes)
    classes.each { |c| create_class(c) }
  end

  def create_kraken_class(klass)
    if Kraken.const_defined?(klass.name)
      return Kraken.const_get(klass.name)
    end

    kraken_klass = Class.new(klass)
    Kraken.const_set(klass.name, kraken_klass)
    kraken_klass
  end

  def create_kraken_classes(*classes)
    classes.each { |c| create_kraken_class(c) }
  end
end
