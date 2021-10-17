require_relative 'helper'

module Platform9
  class Client # :nodoc:
    include Platform9::EC2::Helper

    def reservation_request
      instances = {}
      puts 'List of unreserved pool instances: '
      index = 1
      current_pool.each { |instance|
        puts "#{index} :"
        i = instance.instances.first
        puts "  ID : #{i.instance_id}"
        puts "  Private IP : #{i.private_ip_address}"
        puts "  Public IP : #{i.public_ip_address}"
        instances[index.to_s] = i.instance_id
        index += 1
      }
      raise 'No instance available in pool, please contact to admin' if instances.empty?

      puts 'Please select instance number you wanted to check-in/reserve :'
      selected_id = gets
      selected_instance = instances[selected_id.chop]
      raise 'Wrong selection' unless selected_instance

      update_instance_status(selected_instance, 'reserve')
    end

    def release_request(instance_id)
      update_instance_status(instance_id, 'unreserved')
      puts 'Checkout/Release request successfully completed'
    end

    def current_pool
      resp = client.describe_instances(filters:
        [
          { name: 'tag:type', values: ['pool'] },
          { name: 'tag:status', values: ['unreserved'] },
          { name: 'tag:cleanup', values: ['completed'] },
          { name: 'instance-state-name', values: ['running'] }
        ]
      ).reservations
      resp
    end

    def update_instance_status(instance_id, status)
      client.create_tags({
        resources: [
          instance_id
        ],
        tags: [
          {
            key: 'status',
            value: status
          },
          {
            key: 'time',
            value: Time.now.to_s
          },
          {
            key: 'cleanup',
            value: 'TODO'
          }
        ]
      })
    end
  end
end
