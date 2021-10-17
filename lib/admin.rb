require_relative 'helper'

module Platform9
  class Client # :nodoc:
    include Platform9::EC2::Helper
    include Platform9::SSH::Helper

    def run_cleanup
      puts 'List of unreserved pool instances requires cleanup: '
      cleanup_pool.each { |instance|
        i = instance.instances.first
        file_path = File.join(Dir.home, "#{i.key_name}.pem")
        if File.exist?(file_path)
          cleanup(i.public_ip_address, File.open(file_path), 'rm -rf /tmp')
        else
          puts "SSH key for #{i.instance_id} #{i.key_name} doesn't exists, hence skipping cleanup"
        end
        update_instance_status(i.instance_id)
      }
    end

    private

    def cleanup(id, ip)
      #SSH logic goes here
      puts "Performing cleanup for : #{id}"
      # TODO
    end

    def cleanup_pool
      resp = client.describe_instances(filters:
        [
          { name: 'tag:type', values: ['pool'] },
          { name: 'tag:status', values: ['unreserved'] },
          { name: 'tag:cleanup', values: ['TODO'] }
        ]
      ).reservations
      resp
    end

    def update_instance_status(instance_id)
      client.create_tags({
        resources: [
          instance_id
        ],
        tags: [
          {
            key: 'time',
            value: Time.now.to_s
          },
          {
            key: 'cleanup',
            value: 'completed'
          }
        ]
      })
    end
  end
end
