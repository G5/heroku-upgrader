Dir[File.join(Dir.pwd) + "**/*.rb"].each { |file| require file if !file.include?("upgrade.rb") }

def main_menu
  system("clear")
  status=""; choice = ""
  until choice == "x"
    puts "[= Heroku Database Upgrader =]".blue.bold
    status != "" ? puts("Status: ".magenta + "#{status}"+ "\n\n")  : false
    puts "(1) Enter App Name "
    puts "(2) App PG Info"
    puts "(x) Exit "
    print "Enter choice: "
    choice = gets.chomp.to_s
    case choice
    when "1"
      get_app_name
      status = "Getting App Name #{@app_name}"
    else
      status = "Invalid Option"
    end
  end
  puts "Closing program"
end

def get_app_name
  print "App Name: "
  @app_name = gets.chomp.to_s
end

main_menu
