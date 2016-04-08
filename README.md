This is a ruby console application. You must have ruby installed and be able to run it from the command line (like in mac terminal). The purpose of this app is to to simplify and optimize the upgrade of heroku databases. Heroku has significant documentation to explain all the parts of this process. In a nutshell you are going to create a new "addon" which is a new database to be provisioned. Then you are copying the current database into it and promoting the new one. After that you create a backup, create a backup schedule for the DATABASE_URL (the current active database) and then you can start over with a new app and do it again.

There are a few steps to run this:
1. Clone the repository
2. Heroku will need to authenticate, so you must setup your heroku account api token. Put this in the .env file in your application root directory.
HEROKU_BIN_PATH=heroku
HEROKU_AUTH_TOKEN=some_token

To start the program:
$ ruby upgrade.rb
