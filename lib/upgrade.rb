Dir[File.join(Dir.pwd) + "**/*.rb"].each { |file| require file if !file.include?("upgrade.rb") }
include App
require 'pry'
require 'dotenv'
require 'open3'
require 'Bundler'
Dotenv.load

@app_name = "mj-hub"

def main_menu
  choice = ""
  until choice == "x"
    puts "[= Heroku PG Upgrader Main Menu =]".blue.bold
    @app_name.nil? ? (puts "(1) enter heroku appname: ") : (puts "(1) change heroku appname " + "( " + "#{@app_name}".cyan + " )" )
    puts "(2) [= database Upgrade Menu =]"
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
    puts "(1) view pg:info & pg:backups schedules"
    if @addon_color
      puts "(3) copy/promote " + "#{@addon_color}".cyan
    else
      puts "(2) create addon"
    end
    puts "(x) Exit "
    print "Enter choice: "
    choice = gets.chomp.to_s
    case choice
    when "1"
      pg_info
      pg_backups_schedule
    when "2"
      create_addon_choice
    when "3"
      copy_promote_addon
    end
  end
  clear_screen
end


def create_addon_choice
    choice = ""
    puts "This creates the addon the current database will copy into and then this will get promoted:"
    puts "Upgrade to " + "(B)".green + "asic $9/mo" + " OR " + "(S)".red + "tandard $50/mo"
    choice = gets.chomp.to_s.downcase
    if choice == "b"
      addon_url = "heroku addons:create heroku-postgresql:hobby-basic -a #{@app_name}"
      create_addon(addon_url)
    elsif choice == "s"
      addon_url = "heroku addons:create heroku-postgresql:hobby-dev -a #{@app_name}"
      create_addon(addon_url)
    else
      puts "Canceling create addon, invalid choice."
    end
end

def clear_screen
  system("clear")
end

clear_screen
main_menu
