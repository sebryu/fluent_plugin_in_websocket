# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-in-websocket"
  spec.version       = "0.1.2"
  spec.authors       = ["Sebastian Szewczyk"]
  spec.email         = ["sebryu@gmail.com"]

  spec.summary       = "Fluent plugin for websocket input"
  spec.description   = "Fluent plugin that uses em-websocket as input. Don't have tests yet, but it works for me. For more info visit homepage https://github.com/sebryu/fluent_plugin_in_websocket."
  spec.homepage      = "https://github.com/sebryu/fluent_plugin_in_websocket"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_runtime_dependency "fluentd", [">= 0.11.0", "< 2"]
  spec.add_runtime_dependency "em-websocket", "~> 0.5.1"
end
