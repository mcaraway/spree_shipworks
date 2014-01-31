$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "spree/shipworks/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "spree_shipworks"
  s.version     = Spree::Shipworks::VERSION
  s.authors     = ["M. Scott Ford"]
  s.email       = ["scott@railsdog.com"]
  s.homepage    = "http://railsdog.com"
  s.summary     = "Spree ShipWorks"
  s.description = "This project implements the ShipWorks 3.0 API endpoint as defined in 'ShipWorks 3.0: Store Integration Guide: version 1.0'."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "spree", "~> 2.1.0"
  s.add_dependency "nokogiri", "~> 1.6.0"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'rspec-rails',  '~> 2.14.0'
  s.add_development_dependency "pry"
end
