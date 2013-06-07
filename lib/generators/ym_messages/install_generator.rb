module YmMessages
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include YmCore::Generators::Migration
      include YmCore::Generators::Ability

      source_root File.expand_path("../templates", __FILE__)
      desc "Installs YmMessages."

      def manifest
        # examples ->
        # copy_file "models/page.rb", "app/models/page.rb"
        # if should_add_abilities?('Page')
        #   add_ability(:open, "can :show, Page, :draft => false")
        # end
        # try_migration_template "migrations/create_pages.rb", "db/migrate/create_pages"
   
        Dir[File.dirname(__FILE__) + '/templates/models/*.rb'].each do |file_path|
          file_name = file_path.split("/").last          
          copy_file "models/#{file_name}", "app/models/#{file_name}"
        end
        
        # Migrations must go last
        Dir[File.dirname(__FILE__) + '/templates/migrations/*.rb'].each do |file_path|
          file_name = file_path.split("/").last
          try_migration_template "migrations/#{file_name}", "db/migrate/#{file_name.sub(/^\d+\_/, '')}"
        end
      end

    end
  end
end