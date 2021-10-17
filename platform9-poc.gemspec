Gem::Specification.new do |spec|
  spec.name        = 'platform9-poc'
  spec.version     = '0.1.0'
  spec.licenses    = ['Apache-2.0']
  spec.summary     = "This is gem to manage aws ec2 resource pool"
  spec.description = "This is gem to manage aws ec2 resource pool"
  spec.authors     = ["Ramesh Sencha"]
  spec.email       = 'rameshsencha7@gmail.com'
  spec.homepage    = 'https://github.com/Ramesh7/platform9-poc'
  spec.metadata    = { "source_code_uri" => "https://github.com/Ramesh7/platform9-poc" }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.0'
  spec.files         = Dir['lib/**/*.rb', 'templates/*.erb', 'templates/*.rb']
  spec.add_runtime_dependency('aws-sdk-ec2', '~> 1')
  spec.add_runtime_dependency('net-ssh', '~> 6')
  spec.add_development_dependency('pry')
end
