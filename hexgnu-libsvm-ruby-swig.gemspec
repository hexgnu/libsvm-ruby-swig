Gem::Specification.new do |s|
  s.name = %q{hexgnu-libsvm-ruby-swig}
  s.version = "0.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Tom Zeng", "Matthew Kirk"]
  s.date = %q{2011-04-17}
  s.description = %q{Ruby wrapper of LIBSVM using SWIG}
  s.email = %q{matt@matthewkirk.com}
  s.extensions << "ext/extconf.rb"
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.rdoc"]
  files =  ["History.txt", "COPYING", "AUTHORS", "Manifest.txt", "README.rdoc", "Rakefile"]
  files << ["lib/hex-svm.rb", "lib/libsvm/model.rb", "lib/libsvm/parameter.rb", "lib/libsvm/problem.rb"]
  files << ["ext/libsvm_wrap.cxx", "ext/svm.cpp", "ext/svm.h", "ext/extconf.rb"]
  s.files = files.flatten
  s.has_rdoc = false
  s.homepage = %q{http://www.matthewkirk.com}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib","ext"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Ruby wrapper fork of Tom Zeng's libsvm wrapper}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<hoe>, [">= 1.8.3"])
    else
      s.add_dependency(%q<hoe>, [">= 1.8.3"])
    end
  else
    s.add_dependency(%q<hoe>, [">= 1.8.3"])
  end
end
