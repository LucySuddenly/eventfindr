require_relative "../config/environment"
require_relative "./cli.rb"

# You will run this file to start up your CLI!
# I've created a rake task for you to run it quickly: `rake run`!
# I've also created a CLI functional class for you: feel free
#   to use it to encapsulate your CLI methods! Run this file
#   to see it go!


# Here's some example code:
cli = CLI.new
cli.main_menu
