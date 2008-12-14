Gem::Specification.new do |s|
  s.name = %q{xhtmldiff}
  s.version = "1.0.0"
  s.date = Time.now
  s.summary = %q{XHTMLDiff is a tool and library for taking valid XHTML documents as input, and generating redlined valid XHTML text highlighting the changes between them as output.}
  s.author = %q{Aredridel}
  s.email = %q{aredridel@nbtsc.org}
  s.homepage = %q{http://theinternetco.net/projects/ruby/xhtmldiff}
  s.has_rdoc = true
  s.required_ruby_version = Gem::Version::Requirement.new(">= 1.8.0")
  s.add_dependency('diff-lcs', '>= 1.1.1')
  s.files = Dir.glob('**/*').delete_if {|item| item.include?('.svn')} 
  s.require_path = %q{lib}
  s.rdoc_options = ["--main", "README"]
  s.extra_rdoc_files = ["README"]
  s.executable = %q{xhtmldiff}
  s.bindir = %q{bin}
end
