require 'rspec'
require 'name_matcher/extractor'
require 'name_matcher/parser'

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

describe NameMatcher::NameItem do

  context "for personal name entries" do

    let (:name) {
      "William the Lucky"
    }

    let (:date_source) {
      NameMatcher::Parser::DateSource.new(Date.new(2018, 01, 22), "East")
    }

    def item(name, date_source)
      NameMatcher::NameItem.new(match_name = 'ignored',
        date = date_source,
        name = name,
        owner = name)
    end

    it "displays the name" do
      expect(item(name, date_source).display).to include(name)
    end

    it "displays the date" do
      expect(item(name, date_source).display).to include("January 22, 2018")
    end
  end
end
