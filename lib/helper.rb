module Platform9
  module EC2
    module Helper
      require 'aws-sdk-ec2'

      DEFAULT_REGION = 'us-east-1'.freeze

      def credentials
        raise "Please export keys in ENV variables" if ENV['AWS_ACCESS_KEY_ID'].nil? || ENV['AWS_SECRET_ACCESS_KEY'].nil?

        ::Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'], ENV['AWS_SESSION_TOKEN'])
      end

      def resource
        ::Aws::EC2::Resource.new(region: region)
      end

      def client
        ::Aws::EC2::Client.new(
          region: region,
          credentials: credentials
        )
      end

      def region
        ENV['AWS_REGION'] || DEFAULT_REGION
      end
    end
  end

  module SSH
    module Helper
      require 'net/ssh'

      def cleanup(ip, key, command)
        Net::SSH.start(ip, 'root', key_data: key) do |ssh|
          output = ssh.exec!(command)
          puts output
        end
      end
    end
  end
end
