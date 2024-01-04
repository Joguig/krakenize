require 'krakenize'

module Krakenize
  require 'rails'

  class Railtie < Rails::Railtie
    initializer 'krakenize.insert_into_active_record' do
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::Base.send(:include, Krakenize)
      end
    end
  end
end
