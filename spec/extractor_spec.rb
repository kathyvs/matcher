
require 'rspec'
require 'extractor'
require 'parser'

describe "PersonalExtractor" do

  let (:extractor) {
    NameMatcher::PersonalExtractor.new
  }

  let (:date_source) {
    "DATE_SOURCE"
  }

  context "for entries of type 'Primary Personal Name' (N)" do

    def extract_item(name)
      extractor.extract_item(NameMatcher::Parser::ParsedItem.new(name, date_source, "N"))
    end

    it "Pulls out the first element in the normal case" do
      name = "John the Smith"
      result = extract_item(name)
      expect(result).to eq(
        NameMatcher::NameItem.new(match_name = name,
          date = date_source,
          name = name,
          owner = name))
    end

    it "normalizes special characters for the primary name" do
      name = "Eoin Ó Briain"
      result = extract_item(name)
      expect(result).to eq(
        NameMatcher::NameItem.new(match_name = 'Eoin O Briain',
          date = date_source,
          name = name,
          owner = name))
    end

  end

end

describe "NonPersonalExtractor" do
end
