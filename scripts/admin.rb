require './lib/admin'
require 'pry'

client = Platform9::Admin.new
client.run_cleanup
