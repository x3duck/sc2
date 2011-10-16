# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "sc2"
  s.version     = "0.0.5"
  s.authors     = ["vasechika"]
  s.email       = ["second.pilot@gmail.com"]
  s.homepage    = "https://github.com/vasechika/sc2"
  s.summary     = "SC 2"
  s.description = "Gem for parsing Starcraft 2 replays"

  s.rubyforge_project = "sc2"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_runtime_dependency "rest-client"
  s.add_development_dependency "rspec"
  s.add_dependency "bindata"
  s.add_dependency "bzip2-ruby"
end
