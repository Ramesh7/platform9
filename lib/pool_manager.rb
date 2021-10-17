require_relative 'helper'

module Platform9
  class PoolManager
    include Platform9::EC2::Helper

    attr_reader :type, :ami, :size, :key_name

    def initialize(options = {})
      @type = option_vaule(:type, options)
      @ami = option_vaule(:ami, options)
      @size = option_vaule(:size, options)
      @key_name = 'pt-poc'
      create_key_pair
    end

    def create
      current_size = current_pool_size
      expected_size = (@size - current_size)
      puts "Pool Status :\n" \
           "  Current Size : #{current_size}\n" \
           "  Expected Sixe : #{@size}\n" \
           "  Change : #{expected_size}\n"

      (1..expected_size).each { |i|
        instance = resource.create_instances({
                                    image_id: @ami,
                                    instance_type: @type,
                                    max_count: 1,
                                    min_count: 1,
                                    key_name: @key_name
                                  })

        instnace_id = instance.first.data.instance_id
        puts "Provisioned new instance with ID : #{instnace_id}"
        client.create_tags({
          resources: [
            instnace_id
          ],
          tags: [
            {
              key: 'Name',
              value: 'platform9-pool'
            },
            {
              key: 'type',
              value: 'pool'
            },
            {
              key: 'status',
              value: 'unreserved'
            },
            {
              key: 'cleanup',
              value: 'completed'
            }
          ]
        })
        puts "Successfully tagged to #{instnace_id}"
      }
    end

    def current_pool_size
      resp = client.describe_instances(filters:
        [
          { name: 'tag:type', values: ['pool'] }, 
          { name: 'instance-state-name', values: ['running', 'pending'] }
        ]
      ).reservations
      resp.count
    end

    private

    def create_key_pair
      key_pair = client.create_key_pair(key_name: @key_name)
      puts 'Created key pair with below details :' \
           "  Name        : #{key_pair.key_name}" \
           "  Fingerprint : #{key_pair.key_fingerprint}" \
           "  ID          : #{key_pair.key_pair_id}"
      filename = File.join(Dir.home, "#{@key_name}.pem")
      File.open(filename, 'w') { |file| file.write(key_pair.key_material) }
    rescue Aws::EC2::Errors::InvalidKeyPairDuplicate
      puts "Already exists key pair named : #{@key_name}"
    rescue StandardError => e
      puts "Error creating key pair or saving private key file: #{e.message}"
    end

    def option_vaule(key, options)
      options[key] || default_options[key]
    end

    def default_options
      {
        type: 't1.micro',
        ami: 'ami-0921c7e48e76b9ded',
        size: 1
      }
    end
  end
end
