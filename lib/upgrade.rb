Dir[File.join(Dir.pwd) + "**/*.rb"].each { |file| require file if !file.include?("upgrade.rb") }
include App
require 'pry'

def main_menu
  choice = ""
  until choice == "x"
    puts "[= Heroku PG Upgrader Main Menu =]".blue.bold
    @app_name.nil? ? (puts "(1) Enter App Name: ") : (puts "(1) Enter App Name (currently:#{@app_name})")
    puts "(2) [= Database Upgrade Menu =]"
    puts "(x) Exit "
    print "Enter choice: "
    choice = gets.chomp.to_s
    case choice
    when "1"
      get_app_name
    when "2"
      database_upgrade_menu
    end
  end
  puts "Closing program"
end

def database_upgrade_menu
  choice = ""; clear_screen
  until choice == "x"
    puts "[= Database Upgrade Menu =]".blue.bold
    puts "(1) PG Info "
    puts "(2) pg:backups schedules "
    puts "(x) Exit "
    print "Enter choice: "
    choice = gets.chomp.to_s
    case choice
    when "1"
      pg_info
    when "2"
      pg_backups_schedule
    end
  end
  clear_screen
end


def clear_screen
  system("clear")
end

clear_screen
main_menu
