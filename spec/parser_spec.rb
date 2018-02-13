require 'rspec'
require 'date'
require 'parser'
require 'name_matcher'

describe 'Parser' do

  def parse_line(line)
    send(:parser).parse([line]).to_a[0]
  end

  let (:date_source) {
    # Must match date-code
    DateSource.new(date = Date.new(2018, 1), kingdom = "An Tir")
  }

  let (:date_string) {
    "201801N"
  }

  def simple_line(name, type)
    "#{name}|#{date_string}|#{type}||(regid:10000)"
  end

  context "General case" do
    let (:parser) {
      GeneralParser.new
    }

    it "ignores range dates" do
      pending "date parsing"
      expect(parser.parse(["Test Name|201301K-201703K|N||(regid:300000"])).to be_empty
    end
  end

  context "When parsing dates" do

    let (:parser) {
      GeneralParser.new
    }

    def parse_date(date_str)
      parse_line("Test Name|#{date_str}|N||(regid:4000)")[1]
    end

    it "There are at least 18 kingdoms" do
      expect(Parser::KINGDOM_CODES.length).to be >= 18
    end

    it "Takes the first four digits as the year" do
      expect(parse_date("201703N").date.year).to eq(2017)
    end

    it "Takes the newt two digits as the month (starting at 1)" do
      expect(parse_date("201606N").date.month).to eq(06)
    end

    Parser::KINGDOM_CODES.each do |code, kingdom|
      it "Translates the last letter #{code} to #{kingdom}" do
        expect(parse_date("201503#{code}").kingdom).to eq(kingdom)
      end
    end

  end

  context "When searching for personal names" do

    let (:parser) {
      PersonalParser.new
    }

    it "Pulls out the first element in the normal case" do
      name = "John the Smith"
      result = parse_line(simple_line(name, "N"))
      expect(result).to eq(
        NameItem.new(match_name = name,
          date = date_source,
          name = name,
          owner = name))
    end

    it "Normalizes special characters" do
      name = "Eoin Ó Briain"
      result = parse_line(simple_line(name, "N"))
      expect(result).to eq(
        NameItem.new(match_name = 'Eoin O Briain',
          date = date_source,
          name = name,
          owner = name))
    end


  end

  context "When searching for non personal names"
end

#
# Used to test things outside of whether it is a personal or non personal name
#
class GeneralParser < Parser

  def parse_items(name, date, type, extra, *rest)
    return ["{name}:{extra}", date]
  end
end
