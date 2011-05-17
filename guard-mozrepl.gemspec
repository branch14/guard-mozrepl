$:.push File.expand_path("../lib", __FILE__)
require "guard/mozrepl/version"

Gem::Specification.new do |s|
  s.name        = "guard-mozrepl"
  s.version     = Guard::Mozrepl::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Phil Hofmann"]
  s.email       = ["phil@branch14.org"]
  s.homepage    = "http://branch14.org/guard-mozrepl"
  s.summary     = %q{make guard reload the current tab when things change}
  s.description = %q{make guard reload the current tab when things change}

  #s.rubyforge_project = "guard-mozrepl"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
