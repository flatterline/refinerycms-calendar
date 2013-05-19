# Encoding: UTF-8

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = 'refinerycms-calendar'
  s.version           = '2.0.4'
  s.authors           = ['Philip Arndt', 'Joe Sak']
  s.description       = 'Ruby on Rails Calendar extension for Refinery CMS'
  s.date              = '2013-02-05'
  s.summary           = 'Calendar extension for Refinery CMS'
  s.require_paths     = %w(lib)
  s.files             = Dir["{app,config,db,lib,vendor}/**/*"] + ["readme.md"]

  # Runtime dependencies
  s.add_dependency 'refinerycms-core', '~> 2.0.10'

  # Development dependencies (usually used for testing)
  s.add_development_dependency 'refinerycms-testing', '~> 2.0.10'
end
