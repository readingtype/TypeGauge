lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
  s.name = "type_gauge"
  s.version = 0.1
  s.summary = "Try to parse useful type size information from a string"
  s.platform = Gem::Platform::RUBY

  s.files = ['lib/type_gauge.rb', 'lib/constants.rb']

  s.require_path = "lib"
  s.has_rdoc = false

  s.author = "Ben Weiner"
  s.email = "ben@readingtype.org.uk"
  s.license = "BSD"
end