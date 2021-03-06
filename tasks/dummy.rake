namespace :dummy do
  desc "Generate a Rails dummy for ActivityEngine tests"
  task :generate => [:init, :new_app, :install, :scaffold, :migrate, :cleanup]

  desc 'Remove dummy application'
  task :remove => :init do
    require 'fileutils'
    $stdout.puts "Removing spec/dummy"
    DummyFileUtils.rm_rf(DUMMY_ROOT)
  end

  desc "Replace the existing Rails dummy for ActivityEngine tests"
  task :regenerate => [:remove, :generate]


  task :new_app => [:init] do
    # Cribbed from https://gist.github.com/stas/4131823
    require 'rails'
    require 'activity_engine'
    require 'rails/generators'
    require 'rails/generators/rails/plugin_new/plugin_new_generator'

    class DummyGenerator < Rails::Generators::PluginNewGenerator

      def self.default_source_root
        Rails::Generators::PluginNewGenerator.default_source_root
      end

      def do_nothing
      end

      alias :create_root :do_nothing
      alias :create_root_files :do_nothing
      alias :create_app_files :do_nothing
      alias :create_config_files :do_nothing
      alias :create_lib_files :do_nothing
      alias :create_public_stylesheets_files :do_nothing
      alias :create_javascript_files :do_nothing
      alias :create_script_files :do_nothing
      alias :update_gemfile :do_nothing
      alias :create_test_files :do_nothing
      alias :finish_template :do_nothing

    end
    puts "Generating #{DUMMY_ROOT}"
    DummyGenerator.start(
      %W(. --force --skip-bundle --old-style-hash --dummy-path=#{DUMMY_ROOT})
    )
  end

  task :scaffold => [:init, :new_app, :install] do
    system("rails generate scaffold Watch")
    system("rails generate scaffold Gear")
    system("rails generate scaffold Invisible")

    require 'generators/activity_engine/register_controller_generator'
    # require 'debugger'; debugger; true
    system("rails generate activity_engine:register_controller Watch create")

    # require 'debugger'; debugger; true
    Rake::Task['dummy:cleanup'].invoke
  end

  task :install => [:init, :new_app] do
    puts "Installing ActivityEngine"
    require 'generators/activity_engine/install_generator'
    system("rails generate activity_engine:install --force")
  end

  task :cleanup => [:init] do
    system("rm -rf #{File.join(DUMMY_ROOT,'spec')}")
  end

  task :migrate => :init do
    puts "Running activity_engine migrations"
    rakefile = File.join(DUMMY_ROOT, 'Rakefile')
    system("rake -f #{rakefile} db:create db:migrate db:test:prepare")
  end

  task :init do
    DummyFileUtils = FileUtils #::DryRun
    DUMMY_ROOT = File.expand_path("../../spec/dummy", __FILE__).freeze
  end

end
