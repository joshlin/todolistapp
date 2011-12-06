$LOAD_PATH << File.dirname(__FILE__)

require 'lib/todolist'

run Sinatra::Application
