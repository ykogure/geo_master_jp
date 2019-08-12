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

      # def insert_javascript_tag
      #   inject_into_file "app/views/layouts/application.html.erb", after: /<head[\s]?[^>]*>/ do
      #     "\n    <%= render_gtm_on_rails_tag_in_head %>\n"
      #   end
      #   inject_into_file "app/views/layouts/application.html.erb", after: /<body[\s]?[^>]*>/ do
      #     "\n    <%= render_gtm_on_rails_tag_in_body %>\n"
      #   end
      # end

      def self.next_migration_number(dirname)
        ::ActiveRecord::Generators::Base.next_migration_number(dirname)
      end

      def create_migration_file
        templates = ['create_prefectures', 'create_cities', 'create_towns', 'create_railway_companies', 'create_lines', 'create_stations', 'create_station_connections', 'create_versions']

        migration_dir = File.expand_path("db/migrate")
        templates.each do |template|
          if self.class.migration_exists?(migration_dir, template)
            ::Kernel.warn "Migration already exists: #{template}"
          else
            migration_template(
              "#{template}.rb.erb",
              "db/migrate/#{template}.rb",
              migration_version: migration_version
            )
          end
        end
      end

      private

        def migration_version
          major = ActiveRecord::VERSION::MAJOR
          if major >= 5
            "[#{major}.#{ActiveRecord::VERSION::MINOR}]"
          end
        end

    end
  end
end
