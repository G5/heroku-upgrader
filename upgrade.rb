Dir[File.join(Dir.pwd) + "/lib/**/*.rb"].each { |file| require file if !file.include?("upgrade.rb") }
#require 'pry'
require 'dotenv'
require 'open3'
require 'Bundler'
include App
Dotenv.load
@state = State.new

def main_menu
  choice = ""
  until choice == "x"
    puts "[= Heroku PG Upgrader Main Menu =]".blue.bold
    @state.joined ? (puts "(1) Change heroku appname " + "( " + "#{@app_name}".cyan + " )" ) : ( puts "(1) Enter heroku appname: ")  
    puts "(2) [= DB Upgrade Menu =]" if @state.joined
    puts "(x) Exit "
    print "Enter choice: "
    choice = gets.chomp.to_s
    case choice
    when "1"
      get_app_name
    when "2"
      @app_name.nil? ? (puts "You need a valid Heroku appname") : database_upgrade_menu
    end
  end
  puts "Closing program"
end

def database_upgrade_menu
  choice = ""; clear_screen
  until choice == "x"
    puts "[= Database Upgrade Menu =] ".blue.bold + "#{@app_name}".cyan 
    puts "(1) View " + "pg:info".green + " & " + "pg:backups schedules".green
    puts "(2) Create new Addon" if  !@state.addon_created
    puts "(3) Copy & Promote (" + "pg:copy ".green + "&" + " pg:promote".green + ") new Addon " + "#{@addon_color}".cyan if @state.addon_created && !@state.addon_promoted
    puts "(4) Finish upgrade - (" + "maintenance:off".green + " & " + "pg:backups capture/schedule".green + ")" if @state.addon_promoted && !@state.finalized
    puts "(10) Clean Schedules"
    puts "-== Upgrade is completed ==-".red if @state.finalized
    puts "(x) Exit to Main Menu"
    print "Enter choice: "
    choice = gets.chomp.to_s
    case choice
    when "1"
      pg_info
      get_schedules
      dyno_info
    when "2"
      create_addon_type
    when "3"
      addon_copy
      addon_promote if @state.addon_copied
      pg_info
    when "4"
      finalize_upgrade
    when "10"
      clean_schedules
    end
  end
  clear_screen
end


def create_addon_type
    choice = ""
    puts "This creates the addon the current database will copy into and then this will get promoted:"
    puts "Upgrade to " + "(B)asic $9/mo ".green + "OR " + "(S)tandard-0 $50/mo ".red + "OR " + "(F)ree ".cyan + "plan for testing."
    puts ""
    choice = gets.chomp.to_s.downcase
    if choice == "b"
      addon_url = "heroku addons:create heroku-postgresql:hobby-basic -a #{@app_name}"
      create_addon(addon_url)
    elsif choice == "f"
      addon_url = "heroku addons:create heroku-postgresql:hobby-dev -a #{@app_name}"
      create_addon(addon_url)
    elsif choice == "s"
      addon_url = "heroku addons:create heroku-postgresql:standard-0 -a #{@app_name}"
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
