module YmMessages
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include YmCore::Generators::Migration
      include YmCore::Generators::Ability

      source_root File.expand_path('../templates', __FILE__)
      desc 'Installs YmMessages.'

      def manifest
        # examples ->
        # copy_file 'models/page.rb', 'app/models/page.rb'
        # if should_add_abilities?('Page')
        #   add_ability(:open, 'can :show, Page, :draft => false')
        # end
        # try_migration_template 'migrations/create_pages.rb', 'db/migrate/create_pages'
        tabbed_space = "\n      "
        if should_add_abilities?('Message')
          add_ability(:user, 'can :new, Message')
          add_ability(:user, "can :create, Message do |message| #{tabbed_space}  (message.thread.try(:users) || []).none?(&:no_private_messaging?)#{tabbed_space}end")
        end
        if should_add_abilities?('MessageThread')
          add_ability(:user, 'can :index, MessageThread')
          add_ability(:user, "can :show, MessageThread do |thread|#{tabbed_space}  thread.users.exists?(:id => user.id)#{tabbed_space}end")
        end
   
        Dir[File.dirname(__FILE__) + '/templates/models/*.rb'].each do |file_path|
          file_name = file_path.split('/').last          
          copy_file "models/#{file_name}", "app/models/#{file_name}"
        end
        
        Dir[File.dirname(__FILE__) + '/templates/controllers/*.rb'].each do |file_path|
          file_name = file_path.split('/').last          
          copy_file "controllers/#{file_name}", "app/controllers/#{file_name}"
        end
        
        # Migrations must go last
        Dir[File.dirname(__FILE__) + '/templates/migrations/*.rb'].each do |file_path|
          file_name = file_path.split('/').last
          try_migration_template "migrations/#{file_name}", "db/migrate/#{file_name.sub(/^\d+\_/, '')}"
        end
      end
    end
  end
end