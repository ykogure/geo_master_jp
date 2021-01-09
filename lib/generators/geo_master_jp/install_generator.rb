require "rails/generators"
require "rails/generators/active_record"

module GeoMasterJp
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include ::Rails::Generators::Migration

      source_root File.expand_path('templates', __dir__)

      desc "Creates a Geo Master Jp initializer to your application."

      def copy_initializer
        template "geo_master_jp.rb", "config/initializers/geo_master_jp.rb"
      end
    end
  end
end
