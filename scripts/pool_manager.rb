require './lib/pool_manager'
require 'pry'

client = Platform9::PoolManager.new({ size: 3 })
client.create
# With custom params :
# Platform9::PoolManager.new(type: 't2.micros', ami: 'ami-xxxx', size: 5)
