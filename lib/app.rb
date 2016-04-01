module App

  def get_app_name
    print "Enter App Name: "
    @app_name = gets.chomp.to_s
    join_app
  end

  def join_app
    puts "joining app..."
    join_url = "heroku join -a #{@app_name}"
    pg_info, stderr, status = Bundler.with_clean_env {Open3.capture3(join_url)}
    if status.success?
      puts "Joined #{@app_name} successfully".green
    else
      @app_name = nil
      puts "Error: ".red + "#{stderr}"
    end
  end

  def pg_info
    puts "getting pg:info..."
    get_pg_url = "heroku pg:info -a #{@app_name}"
    pg_info, stderr, status = Bundler.with_clean_env {Open3.capture3(get_pg_url)}
    if status.success?
      puts "-=[Heroku pg info for " + "#{@app_name}".cyan + "]=-"
      puts pg_info.green
    else
      puts "Error: ".red + "#{stderr}"
    end
  end

  def pg_backups_schedule
    puts "getting backup schedule(s)..."
    get_pg_url = "heroku pg:backups schedules -a #{@app_name}"
    pg_info, stderr, status = Bundler.with_clean_env {Open3.capture3(get_pg_url)}
    if status.success?
      puts "-=[Heroku pg:backups schedules for " + "#{@app_name}".cyan + "]=-"
      puts pg_info.green
    else
      puts "Error: ".red + "#{stderr}"
    end
  end

  def create_addon(addon_url)
    puts "creating addon..."
    addon_create, stderr, status = Bundler.with_clean_env {Open3.capture3(addon_url)}
    puts addon_create.to_s.green
    @addon_color = addon_create.slice(/HEROKU\w+/)
  end

  def copy_promote_addon
    wait = "heroku pg:wait -a #{@app_name}"
    maintenance = "heroku maintenance:on -a #{@app_name}"
    pg_copy = "heroku pg:copy DATABASE_URL #{@addon_color} --confirm #{@app_name}"
    pg_promote = "heroku pg:promote #{@addon_color} -a #{@app_name}"

    puts "putting database in wait state...".green
    open3_capture(wait)
    puts "setting maintenance mode on #{@app_name}...".green
    open3_capture(maintenance)
    puts "copying DATABASE_URL to new addon #{@addon_color}...".green
    copy_result = open3_capture(pg_copy)
    if copy_result[0].include?("Copy completed")
      puts "promoting #{@addon_color} to DATABASE_URL...".green
      open3_capture(pg_promote)
    end
  end 

  def finalize_upgrade
    maintenance = "heroku maintenance:off -a #{@app_name}"
    schedule = "heroku pg:backups schedule --at '02:00 America/Los_Angeles' DATABASE_URL --app #{@app_name}"
    capture = "heroku pg:backups capture -a #{@app_name}" 
    maint_result = open3_capture(maintenance)
    puts maint_result[1].green
    cap_result = open3_capture(schedule)
    puts cap_result[0].green
    sched_result = open3_capture(capture)
    puts sched_result[0].green
    puts "database upgrade complete.".cyan
  end

  def open3_capture(url)
    capture_result, stderr, status = Bundler.with_clean_env {Open3.capture3(url)}
    return [capture_result, stderr, status]
  end

end
