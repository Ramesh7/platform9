require './lib/client'
require 'pry'

client = Platform9::Client.new
# reserve instance / check-in instance
# client.reservation_request

# unreserve instance / check-out instance
client.release_request('i-0e8bbebcbb9ddad72')
