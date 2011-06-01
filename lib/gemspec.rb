#!/usr/bin/env ruby
require File.expand_path('../../lib/refinery.rb', __FILE__)
files = %w( .gitignore .yardopts Gemfile *.md ).map { |file| Dir[file] }.flatten
%w(app bin config db features lib public script spec test themes vendor).sort.each do |dir|
  files += Dir.glob("#{dir}/**/*")
end
rejection_patterns = [
  "public\/system",
  "^config\/(application|boot|environment).rb$",
  "^config\/initializers(\/.*\.rb)?$",
  "^config\/(database|i18n\-js).yml$",
  "^public\/",
  "^lib\/gemspec\.rb",
  ".*\/cache\/",
  "^db\/(schema.rb|.*\.sqlite3?(-journal)?)$",
  "^script\/*",
  "^vendor\/plugins\/?$",
  "\.log$",
  "\.rbc$"
]

files.reject! do |f|
  !File.exist?(f) or f =~ %r{(#{rejection_patterns.join(')|(')})} or (File.directory?(f) and Dir[File.join(f, "*")].empty?)
end

gemspec = <<EOF
# DO NOT EDIT THIS FILE DIRECTLY! Instead, use lib/gemspec.rb to generate it.

Gem::Specification.new do |s|
  s.name              = %q{refinerycms}
  s.version           = %q{#{Refinery.version}}
  s.description       = %q{A Ruby on Rails CMS that supports Rails 3. It's easy to extend and sticks to 'the Rails way' where possible.}
  s.date              = %q{#{Time.now.strftime('%Y-%m-%d')}}
  s.summary           = %q{A Ruby on Rails CMS that supports Rails 3}
  s.email             = %q{info@refinerycms.com}
  s.homepage          = %q{http://refinerycms.com}
  s.rubyforge_project = %q{refinerycms}
  s.authors           = ['Resolve Digital', 'David Jones', 'Philip Arndt']
  s.license           = %q{MIT}
  s.require_paths     = %w(lib)
  s.executables       = %w(#{Dir.glob('bin/*').map{|d| d.gsub('bin/','')}.join(' ')})

  s.add_dependency    'acts_as_indexed',             '~> 0.6.6'
  s.add_dependency    'authlogic',                   '~> 2.1.6'
  s.add_dependency    'bundler',                     '~> 1.0.5'
  s.add_dependency    'dragonfly',                   '~> 0.9.2'
  s.add_dependency    'friendly_id_globalize3'
  s.add_dependency    'globalize3'
  s.add_dependency    'moretea-awesome_nested_set',  '= 1.4.3.1'
  s.add_dependency    'rack-cache',                  '~> 0.5.2'
  s.add_dependency    'rails',                       '~> 3.0.3'
  s.add_dependency    'rdoc',                        '>= 2.5.11' # helps fix ubuntu
  s.add_dependency    'truncate_html',               '= 0.4'
  s.add_dependency    'will_paginate',               '~> 3.0.pre'

  s.add_development_dependency 'rspec-rails',        '~> 2.3'
  # Cucumber
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'cucumber-rails'
  s.add_development_dependency 'cucumber'
  s.add_development_dependency 'launchy'
  s.add_development_dependency 'gherkin'
  s.add_development_dependency 'rack-test',          '~> 0.5.6'
  # FIXME: Update json_pure to 1.4.7 when it is released
  s.add_development_dependency 'json_pure',          '~> 1.4.6'
  # Factory Girl
  s.add_development_dependency 'factory_girl'
  # Autotest
  s.add_development_dependency 'autotest'
  s.add_development_dependency 'autotest-rails'
  s.add_development_dependency 'autotest-notification'

  #s.add_dependency('refinerycms-authentication', '#{Refinery.version}')
  #s.add_dependency('refinerycms-base',           '#{Refinery.version}')
  #s.add_dependency('refinerycms-core',           '#{Refinery.version}')
  #s.add_dependency('refinerycms-dashboard',      '#{Refinery.version}')
  #s.add_dependency('refinerycms-images',         '#{Refinery.version}')
  #s.add_dependency('refinerycms-pages',          '#{Refinery.version}')
  #s.add_dependency('refinerycms-resources',      '#{Refinery.version}')
  #s.add_dependency('refinerycms-settings',       '#{Refinery.version}')

  s.files             = [
    '#{files.sort.join("',\n    '")}'
  ]
end
EOF

File.open(File.expand_path("../../refinerycms.gemspec", __FILE__), 'w').puts(gemspec)
