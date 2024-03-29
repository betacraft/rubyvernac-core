# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
file_list = `git ls-files -z`.split("\x0")
file_list = `git ls-files -z -o --exclude-standard | xargs -0`.split(" ") if file_list.empty?

require 'rubyvernac/__lang__/version'

Gem::Specification.new do |spec|
  spec.name          = "rubyvernac-__lang__"
  spec.version       = Rubyvernac::__Lang__::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ["mathew"]
  spec.email         = ["mathew@betacraft.com"]

  spec.summary       = %q{: Write a short summary. Required.}
  spec.description   = %q{: Write a longer description. Optional.}
  spec.homepage      = "https://github.com/betacraft/rubyvernac-__lang__"
  spec.license       = "MIT"

  spec.files         = file_list
  spec.require_paths = ["lib"]
  spec.executables   << "ruby___lang__"
  spec.required_ruby_version = '>= 2.7'

  spec.add_development_dependency "rake"
end
