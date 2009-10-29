# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rubsh}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Daniel Bretoi"]
  s.date = %q{2009-10-29}
  s.default_executable = %q{rubsh}
  s.description = %q{A ruby shell}
  s.email = %q{daniel@netwalk.org}
  s.executables = ["rubsh"]
  s.extra_rdoc_files = ["CHANGELOG", "README.rdoc", "bin/rubsh", "lib/alias.rb", "lib/commands.rb", "lib/prompt.rb", "lib/rub_readline.rb", "lib/rubsh.rb"]
  s.files = ["CHANGELOG", "README.rdoc", "Rakefile", "bin/rubsh", "lib/alias.rb", "lib/commands.rb", "lib/prompt.rb", "lib/rub_readline.rb", "lib/rubsh.rb", "Manifest", "rubsh.gemspec"]
  s.homepage = %q{http://github.com/danielb2/rubsh}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Rubsh", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rubsh}
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{A ruby shell}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
