$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "geo_master_jp/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "geo_master_jp"
  spec.version     = GeoMasterJp::VERSION
  spec.authors     = ["ykogure"]
  spec.email       = ["renkin1008@gmail.com"]
  spec.homepage    = "https://github.com/ykogure/geo_master_jp"
  spec.summary     = "Summary of GeoMasterJp."
  spec.description = "Description of GeoMasterJp."
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_runtime_dependency "rails", "~> 7"
  spec.add_runtime_dependency "rubyzip"
  spec.add_runtime_dependency "romaji"
  spec.add_runtime_dependency "activerecord-import"

  spec.add_development_dependency "mysql2"
end
