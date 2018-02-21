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

    it "Pulls out the first element as primary name and owner" do
      name = "John the Smith"
      result = extract_item(name)
      expect(result.name).to eq(name)
      expect(result.owner).to eq(name)
    end

    it "copies data source" do
      result = extract_item("Data Source Test")
      expect(result.date_source).to eq(date_source)
    end

    it "normalizes special characters for the match name" do
      name = "Eoin Ó Briain"
      result = extract_item(name)
      expect(result.match_name).to eq('Eoin O Briain')
    end

  end

  context "for entries of type 'Alternate Personal Name' (AN)" do

    attr_reader :result

    let (:primary_name) {
      "John the Smith"
    }

    let (:alternate_name) {
      "John the Baker"
    }

    before do
      @result = extractor.extract_item(
        NameMatcher::Parser::ParsedItem.new(alternate_name, date_source, "AN", primary_name))
    end

    it "pulls out the first element (alternate name) as the name element of the item" do
      expect(result.name).to eq(alternate_name)
    end

  end

  context "for other entries" do

    it "skips the item" do
      item = NameMatcher::Parser::ParsedItem.new("Test", date_source, "D", "ignored")
      expect(extractor.extract_item(item)).to be_nil
    end
  end

end

describe "NonPersonalExtractor" do
end

describe NameMatcher::NameItem do

  context "for personal name entries" do

    let (:name) {
      "Eoin Ó Briain"
    }

    let (:date_source) {
      NameMatcher::Parser::DateSource.new(Date.new(2018, 01, 22), "East")
    }

    def item
      NameMatcher::NameItem.new(name, date_source, name)
    end

    it "displays the name" do
      expect(item.display).to include(name)
    end

    it "displays the date" do
      expect(item.display).to include("January 22, 2018")
    end

    it "displays the kingdom" do
      expect(item.display).to include(date_source.kingdom)
    end

    it "does not display the match name" do
      expect(item.display).to_not include("O Briain")
    end
  end

  context "for personal name entries" do

    let (:alternate_name) {
      "Eoin Ó Briain"
    }

    let (:primary_name) {
      "John O'Brian"
    }

    let (:date_source) {
      NameMatcher::Parser::DateSource.new(Date.new(2018, 02, 21), "An Tir")
    }

    def item
      NameMatcher::NameItem.new(alternate_name, date_source, primary_name)
    end

    it "displays the alternate name" do
      expect(item.display).to include(alternate_name)
    end

    it "displays the date" do
      expect(item.display).to include("February 21, 2018")
    end

    it "displays the kingdom" do
      expect(item.display).to include(date_source.kingdom)
    end

    it "displays the owner" do
      expect(item.display).to include("for #{item.owner}")
    end

    it "does not display the match name" do
      expect(item.display).to_not include("O Briain")
    end
  end
end
