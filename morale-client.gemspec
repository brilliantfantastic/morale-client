
Gem::Specification.new do |s|
  s.specification_version = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = '1.3.5'

  s.name              = 'morale-client'
  s.version           = '0.0.1'
  s.date              = '2011-12-12'
  s.rubyforge_project = 'morale-client'

  s.summary     = "A Ruby wrapper for the Morale REST API."
  s.description = "A Ruby wrapper for the Morale REST API. Call the Morale API from any Ruby application to manage tickets and projects."

  s.authors  = ["Brilliant Fantastic"]
  s.email    = 'support@teammorale.com'
  s.homepage = 'http://teammorale.com'

  s.require_paths = %w[lib]

  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[README.md]

  s.add_dependency('httparty', "~> 0.7.8")
  s.add_dependency('json', "~> 1.4.6")

  #s.add_development_dependency('DEVDEPNAME', [">= 1.1.0", "< 2.0.0"])

  ## Leave this section as-is. It will be automatically generated from the
  ## contents of your Git repository via the gemspec task. DO NOT REMOVE
  ## THE MANIFEST COMMENTS, they are used as delimiters by the task.
  # = MANIFEST =
  s.files = %w[
    Gemfile
    Gemfile.lock
    README.md
    Rakefile
    lib/morale.rb
    lib/morale/client.rb
    lib/morale/connection_store.rb
    lib/morale/platform.rb
    lib/morale/storage.rb
    morale-client.gemspec
    spec/morale/client_spec.rb
    spec/morale/connection_store_spec.rb
    spec/spec_helper.rb
  ]
  # = MANIFEST =
end