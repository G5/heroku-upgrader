module App

  def get_app_name
    @state = State.new
    print "Enter app name: "
    @app_name = gets.chomp.to_s
    join_app
  end

  def join_app
    puts "Joining #{@app_name}..."
    join_url = "heroku join -a #{@app_name}"
    pg_info, stderr, status = Bundler.with_clean_env {Open3.capture3(join_url)}
    if status.success?
      puts "Joined #{@app_name} successfully".green
      @state.joined = true
    else
      @app_name = nil
      puts "Error: ".red + "#{stderr}"
      @state.joined = false
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
  
  def dyno_info
    puts "getting dynos detail..."
    get_pg_url = "heroku ps -a #{@app_name}"
    pg_info, stderr, status = Bundler.with_clean_env {Open3.capture3(get_pg_url)}
    if status.success?
      puts "-=[Heroku dynos for " + "#{@app_name}".cyan + "]=-"
      puts pg_info.green
    else
      puts "Error: ".red + "#{stderr}"
    end
  end

  def create_addon(addon_url)
    puts "Creating new Addon..."
    addon_create, stderr, status = Bundler.with_clean_env {Open3.capture3(addon_url)}
    puts addon_create.to_s.green
    @addon_color = addon_create.slice(/HEROKU\w+/)
    @state.addon_created = true
  end

  def addon_copy
    wait = "heroku pg:wait -a #{@app_name}"
    maintenance = "heroku maintenance:on -a #{@app_name}"
    pg_copy = "heroku pg:copy DATABASE_URL #{@addon_color} --confirm #{@app_name}"

    puts "putting database in wait state...".green
    open3_capture(wait)
    puts "setting maintenance mode on #{@app_name}...".green
    open3_capture(maintenance)
    puts "copying DATABASE_URL to new addon #{@addon_color}...".green
    copy_result = open3_capture(pg_copy)
    copy_result[0].include?("Copy completed") ? (@state.addon_copied = true) : (puts "Addon copy failed.")
  end 

  def addon_promote
    pg_promote = "heroku pg:promote #{@addon_color} -a #{@app_name}"
    open3_capture(pg_promote)
    puts "promoting #{@addon_color} to DATABASE_URL...".green
    @state.addon_promoted = true
  end

  def finalize_upgrade
    maintenance = "heroku maintenance:off -a #{@app_name}"
    maint_result = open3_capture(maintenance)
    puts maint_result[1].green
    schedule_and_capture    
    puts "database upgrade complete.".cyan
    @state.finalized = true
  end

  def get_schedules
    puts "getting backup schedule(s)..."
    get_pg_url = "heroku pg:backups schedules -a #{@app_name}"
    pg_info, stderr, status = Bundler.with_clean_env {Open3.capture3(get_pg_url)}
    if status.success?
      @schedules = pg_info.split("\n") ; @schedules.shift
      puts "-=[Heroku pg:backups schedules for " + "#{@app_name}".cyan + "]=-"
      @schedules.each { |s| puts s.green } ; puts ""     
    else
      puts "Error: ".red + "#{stderr}"
    end
  end

  def clean_schedules
    get_schedules
    puts "cleaning up backup schedule(s)..."
    @schedules.each do |schedule| 
      next if schedule.include?("DATABASE_URL")
      sched = schedule.slice(/HEROKU\w+/)
      pg_info, stderr, status = Bundler.with_clean_env {Open3.capture3("heroku pg:backups unschedule #{sched} -a #{@app_name}")}
      if status.success?
        puts "#{schedule} " + "Removed".green
      else
        puts "Error: ".red + "#{stderr}"
      end
    end
    schedule_and_capture
    get_schedules
  end
  
  def schedule_and_capture
    pg_schedule = "heroku pg:backups schedule --at '02:00 America/Los_Angeles' DATABASE_URL --app #{@app_name}"
    pg_capture = "heroku pg:backups capture -a #{@app_name}" 
    sched_result = open3_capture(pg_schedule)
    puts "#{sched_result[0]}".green + " as" + " DATABASE_URL".green
    cap_result = open3_capture(pg_capture)
    puts cap_result[0].green
  end

  def open3_capture(url)
    capture_result, stderr, status = Bundler.with_clean_env {Open3.capture3(url)}
    return [capture_result, stderr, status]
  end

end
