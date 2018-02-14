
require 'rspec'
require 'name_matcher'
require 'parser'

describe "PersonalExtractor"do

  let (:extractor) {
    PersonalExtractor.new
  }

  let (:date_source) {
    "DATE_SOURCE"
  }

  def parse_item(name, type, text)
    return Parser::ParseItem(name, date_source, type, text)


  context "For rows of type Name (N)"

    def simple_parse_item(name)
      return parse_item(name, "N", "")
    end

    it "Pulls out the first element in the normal case" do
      name = "John the Smith"
      result = extractor.extract_item(name, date_source, "N")
      expect(result).to eq(
        NameItem.new(match_name = name,
          date = date_source,
          name = name,
          owner = name))
    end

    it "Normalizes special characters for the matcher" do
      name = "Eoin Ó Briain"
      result = extractor.extract_item(name, date_source, "N")
      expect(result).to eq(
        NameItem.new(match_name = 'Eoin O Briain',
          date = date_source,
          name = name,
          owner = name))
    end

  end
end

describe "NonPersonalExtractor" do
end
