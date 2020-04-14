require 'dotenv'
Dotenv.load

port ENV.fetch('PORT') { 3000 }

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart
