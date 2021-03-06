require 'name_matcher/options'
require 'name_matcher'
#
# Integration tests
#

describe "Integration Tests" do

  context "for personal names" do
    it "matches 'dottir' exactly 3 times" do
      puts File.expand_path('.')
      options = NameMatcher::Options.parse(["dottir", "-f", "spec/data/testoanda.db"])
      result = options.create_matcher.read(options.reader).to_a
      expect(result.length).to eq(3)
    end
  end

end
