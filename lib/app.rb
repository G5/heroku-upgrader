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
      puts "Joined #{@app_name} successfully".green
    else
      @app_name = nil
      puts "Error: ".red + "#{stderr}"
    end
  end

  def pg_info
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
    get_pg_url = "heroku pg:backups schedules -a #{@app_name}"
    pg_info, stderr, status = Bundler.with_clean_env {Open3.capture3(get_pg_url)}
    if status.success?
      puts "-=[Heroku pg:backups schedules for " + "#{@app_name}".cyan + "]=-"
      puts pg_info.green
    else
      puts "Error: ".red + "#{stderr}"
    end
  end

  def create_addon_choice
    addon_choice = ""
    puts "This creates the addon the current database will copy into and then this will get promoted:"
    puts "Upgrade to " + "(B)".green + "asic $9/mo" + " OR " + "(S)".red + "tandard $50/mo"
    addon_choice = gets.chomp.to_s.downcase
    if addon_choice == "b"
      addon_url = "heroku addons:create heroku-postgresql:hobby-dev -a #{@app_name}"
      create_addon(addon_url)
    elsif addon_choice == "s"
      addon_url = "heroku addons:create heroku-postgresql:hobby-dev -a #{@app_name}"
      create_addon(addon_url)
    else
      puts "Canceling create addon, invalid choice."
    end
  end

  def create_addon(addon_url)
    puts addon_url
  end

end
