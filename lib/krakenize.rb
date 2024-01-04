require 'krakenize/railtie'
require 'active_support/concern'

module Krakenize
  extend ActiveSupport::Concern

  class ConfigurationError < StandardError
  end

  module ClassMethods
    # Given an association on a regular ActiveRecord model, this allows you to
    # transfer the association to a Kraken subclass without rewriting the
    # association (and having to maintain two copies of the same association).
    #
    # Given the following regular AR models:
    #
    #   class User < ActiveRecord::Base
    #     has_many :tickets, :foreign_key => :owner_id
    #   end
    #
    #   class Ticket < ActiveRecord::Base
    #   end
    #
    # You can use krakenize_association on the Kraken association:
    #
    #   class Kraken::User < User
    #     # returns Kraken::Ticket objects, if Kraken::Ticket is defined,
    #     # defaulting to Ticket objects if Kraken::Ticket doesn't exist.
    #     krakenize_association :tickets
    #   end
    #
    # There are some cases where this will be imperfect. For example:
    #
    #   class User < ActiveRecord::Base
    #     has_many :teams
    #   end
    #
    #   class Kraken::Channel < User
    #     krakenize_association :teams
    #   end
    #
    # Because the class has been renamed from User to Channel, ActiveRecord
    # tries looking for `channel_id`. To fix this, you can pass a hash to
    # override the association options:
    #
    #   class Kraken::Channel < User
    #     krakenize_association :teams, :foreign_key => 'user_id'
    #   end
    #
    # And now it works!
    def krakenize_association(association_name, options = {})

      if !kraken_model?
        raise ConfigurationError, 'Cannot use krakenize_association on a non-Kraken model.'
      end

      if reflect_on_association(association_name).blank?
        raise ConfigurationError, "Association named '#{association_name}' was not found; perhaps you misspelled it?"
      end

      association = reflections[association_name]
      options = association.options.merge(options)
      options[:class_name] ||= association.klass.to_kraken.name

      __send__(association.macro, association.name, options)
    end

    def kraken_model?
      name.split('::').first == 'Kraken'
    end

    def to_kraken
      if kraken_model? or !Kraken.const_defined?(name.demodulize)
        self
      else
        Kraken.const_get(name.demodulize)
      end
    end
  end
end
