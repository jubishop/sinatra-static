Gem::Specification.new do |spec|
  spec.name          = 'sinatra-static'
  spec.version       = '0.11'
  spec.summary       = %q(Cache-smart serving of static assets for Sinatra.)
  spec.authors       = ['Justin Bishop']
  spec.email         = ['jubishop@gmail.com']
  spec.homepage      = 'https://www.jubigems.org/gems/sinatra-static'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 3.0')
  spec.files         = Dir['lib/**/*.rb']
  spec.require_paths = ['lib']
  spec.bindir        = 'bin'
  spec.executables   = []
  spec.metadata      = {
    'source_code_uri' => 'https://github.com/jubishop/sinatra-static',
    'steep_types' => 'sig'
  }
end
