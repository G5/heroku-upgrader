module App
  def get_app_name
    print "Enter App Name: "
    @app_name = gets.chomp.to_s
    clear_screen
  end

  def pg_info
    puts "heroku pg info for app".cyan
  end

  def pg_backups_schedule
   puts "heroku pg:backups schedules for app".cyan
  end
 
end
