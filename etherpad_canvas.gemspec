$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "etherpad_canvas/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "etherpad_canvas"
  s.version     = EtherpadCanvas::VERSION
  s.authors     = ["Eric Durr"]
  s.email       = ["ericdurr@atomicjolt.com"]
  s.homepage    = "http://atomicjolt.com"
  s.summary     = "Override and add secure signin to Etherpad"
  s.description = "Enable secure sign-in with Etherpad collaborations tool."
  s.license     = "AGPL-3.0"

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 4.2", "< 5.1"
end
