require 'rspec'
require 'date'
require 'name_matcher/parser'

describe 'Parser' do

  def parse_line(line)
    send(:parser).parse([line]).to_a[0]
  end

  let (:date_source) {
    # Must match date-code
    NameMatcher::DateSource.new(date = Date.new(2018, 1), kingdom = "An Tir")
  }

  let (:date_string) {
    "201801N"
  }

  let (:parser) {
    NameMatcher::Parser.new
  }

  it "ignores illegal dates" do
    expect(parser.parse(["Test Name|xxxxx|N||"]).to_a).to be_empty
  end

  it "ignores range dates" do
    expect(parser.parse(["Test Name|201301K-201703K|N||(regid:300000"]).to_a).to be_empty
  end

  context "when parsing dates" do

    def parse_date(date_str)
      parse_line("Test Name|#{date_str}|N||(regid:4000)").date_source
    end

    it "there are at least 18 kingdoms" do
      expect(NameMatcher::Parser::KINGDOM_CODES.length).to be >= 18
    end

    it "takes the first four digits as the year" do
      expect(parse_date("201703N").date.year).to eq(2017)
    end

    it "takes the newt two digits as the month (starting at 1)" do
      expect(parse_date("201606N").date.month).to eq(06)
    end

    NameMatcher::Parser::KINGDOM_CODES.each do |code, kingdom|
      it "translates the last letter #{code} to #{kingdom}" do
        expect(parse_date("201503#{code}").kingdom).to eq(kingdom)
      end
    end

  end

end
