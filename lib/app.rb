module App

  def get_app_name
    print "Enter App Name: "
    @app_name = gets.chomp.to_s
    join_app
  end

  def join_app
    join_url = "heroku join -a #{@app_name}"
    pg_info, stderr, status = Bundler.with_clean_env {Open3.capture3(join_url)}
    if status.success?
      puts "Joined #{@app_name} successfully"
    else
      puts "Error: ".red + "#{stderr}"
    end
  end

  def pg_info
    get_pg_url = "heroku pg:info -a #{@app_name}"
    pg_info, stderr, status = Bundler.with_clean_env {Open3.capture3(get_pg_url)}
    if status.success?
      puts "-=[Heroku pg info for #{@app_name}".cyan
      puts pg_info 
    else
      puts "Error: ".red + "#{stderr}"
    end
  end

  def pg_backups_schedule
   puts "heroku pg:backups schedules for app".cyan
  end
 
end
