require 'rspec'
require 'date'
require 'parser'

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

  let (:parser) {
    Parser.new(SimpleExtractor.new)
  }

  it "ignores range dates" do
    pending "date parsing"
    expect(parser.parse(["Test Name|201301K-201703K|N||(regid:300000"])).to be_empty
  end

  context "when parsing dates" do

    let (:parser) {
      Parser.new(SimpleExtractor.new)
    }

    def parse_date(date_str)
      parse_line("Test Name|#{date_str}|N||(regid:4000)")[1]
    end

    it "there are at least 18 kingdoms" do
      expect(Parser::KINGDOM_CODES.length).to be >= 18
    end

    it "takes the first four digits as the year" do
      expect(parse_date("201703N").date.year).to eq(2017)
    end

    it "takes the newt two digits as the month (starting at 1)" do
      expect(parse_date("201606N").date.month).to eq(06)
    end

    Parser::KINGDOM_CODES.each do |code, kingdom|
      it "translates the last letter #{code} to #{kingdom}" do
        expect(parse_date("201503#{code}").kingdom).to eq(kingdom)
      end
    end

  end

end


#
# Used to test things outside of whether it is a personal or non personal name
#
class SimpleExtractor

  def extract_item(parse_item)
    return ["#{parse_item.name}:#{parse_item.type}:#{parse_item.text}", parse_item.date_source]
  end
end
