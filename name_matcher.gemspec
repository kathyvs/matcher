Gem::Specification.new do |s|
  s.name        = 'name_matcher'
  s.version     = '0.1'
  s.date        = '2018-02-19'
  s.summary     = "Matches names in the SCA OandA"
  s.description = "Searches for matches to name elements in the Society For Creative Anachronism's internal database"
  s.authors     = ["Kathryn Van Stone (Elsbeth Anne Roth)"]
  s.email       = 'elsbeth@pobox.com'
  s.files       = ["lib/name_matcher.rb",
                   "lib/name_matcher/extractor.rb",
                   "lib/name_matcher/options.rb",
                   "lib/name_matcher/parser.rb"]
  s.executables << 'name_matcher'
  s.homepage    =
    'http://rubygems.org/gems/name_matcher'
  s.license       = 'Apache'
end
