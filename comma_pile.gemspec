# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{comma_pile}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jeremy Friesen"]
  s.date = %q{2009-08-14}
  s.email = %q{jeremy.n.friesen@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.markdown"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.markdown",
     "Rakefile",
     "VERSION.yml",
     "comma_pile.gemspec",
     "examples/example_line_parser.rb",
     "lib/comma_pile.rb",
     "lib/comma_pile/config.rb",
     "lib/comma_pile/line_parser.rb",
     "lib/comma_pile/pivot_node.rb",
     "lib/comma_pile/report.rb",
     "test/comma_pile_test.rb",
     "test/fixtures/report.csv",
     "test/test_helper.rb"
  ]
  s.homepage = %q{http://github.com/jeremyf/comma_pile}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{Video Stats for an onstreammedia.com log}
  s.test_files = [
    "test/comma_pile_test.rb",
     "test/test_helper.rb",
     "examples/example_line_parser.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
