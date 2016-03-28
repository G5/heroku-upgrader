module App

  def get_app_name
    print "Enter App Name: "
    @app_name = gets.chomp.to_s
    clear_screen
  end

  def pg_info
    get_pg = "heroku pg:info -a #{@app_name}"
    pg_info, stderr, status = Bundler.with_clean_env {Open3.capture3(get_pg)}
    puts "-=[Heroku pg info for #{@app_name}".cyan
    puts pg_info 
  end

  def pg_backups_schedule
   puts "heroku pg:backups schedules for app".cyan
  end
 
end
