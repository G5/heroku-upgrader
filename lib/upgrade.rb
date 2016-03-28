Dir[File.join(Dir.pwd) + "**/*.rb"].each { |file| require file if !file.include?("upgrade.rb") }
include App
require 'pry'
require 'dotenv'
require 'open3'
require 'Bundler'

Dotenv.load

def main_menu
  choice = ""
  until choice == "x"
    puts "[= Heroku PG Upgrader Main Menu =]".blue.bold
    @app_name.nil? ? (puts "(1) Enter App Name: ") : (puts "(1) Enter App Name (currently:" + "#{@app_name})".cyan)
    puts "(2) [= Database Upgrade Menu =]"
    puts "(x) Exit "
    print "Enter choice: "
    choice = gets.chomp.to_s
    case choice
    when "1"
      get_app_name
    when "2"
      @app_name.nil? ? (puts "Need an Appname") : database_upgrade_menu
    end
  end
  puts "Closing program"
end

def database_upgrade_menu
  choice = ""; clear_screen
  until choice == "x"
    puts "[= Database Upgrade Menu =] ".blue.bold + "#{@app_name}".cyan 
    puts "(1) pg:info"
    puts "(2) pg:backups schedules"
    puts "(3) create the addon"
    puts "(x) Exit "
    print "Enter choice: "
    choice = gets.chomp.to_s
    case choice
    when "1"
      pg_info
    when "2"
      pg_backups_schedule
    when "3"
      create_addon
    end
  end
  clear_screen
end


def clear_screen
  system("clear")
end

clear_screen
main_menu
