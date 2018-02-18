require 'rspec'
require 'name_matcher'
require 'extractor'

describe NameMatcher do

  let(:reader) {
    instance_double('NameMatcher::Reader')
  }

  let(:parser) {
    TestParser.new
  }

  let(:extractor) {
    TestExtractor.new
  }

  def run_matcher(pat, input)
    allow(reader).to receive(:readlines).and_return(input.to_enum)
    name_matcher(pat).run(reader)
  end

  def name_matcher(pat)
    options = {parser: parser, extractor: extractor}
    NameMatcher::Runner.new(pat, options)
  end

  it "filters from the reader to output" do
    input = ["1", "x", "2", "11", "4", "51", "-12"]
    pat = /1/
    result = run_matcher(pat, input).to_a
    expect(result).to include("|1|", "|11|", "|51|")
    expect(result).to_not include("2", "4", "-", "10")
  end

  it "works with real pipeline classes" do
    pending "Adding displayer class"
    options = {extractor: NameMatcher::PersonalExtractor.new}
    lines = ["Test Name|201003X|N||", "Another Name|201104N|N||"]
    allow(reader).to receive(:readlines).and_return(lines.to_enum)
    runner = NameMatcher::Runner.new(/Test/, options)
    result = runner.run(reader)
    expect(result).to include("Test Name")
    expect(result).to_not include("Another Name")
  end
end

#
# Test double for the parser -- converts from string and does a simple filter.
#
class TestParser

  def parse(lines)
    lines.map(&:to_i).select {|i| i != 0}
  end
end

#
# Creates an item from the input value
#
class TestExtractor

  def extract_item(item)
    item > 0 ? Item.new(item.to_s, item) : nil
  end
end

#
# Simplified item for testing
#
class Item < Struct.new(:match_name, :value)

  def display
    "|#{value}|"
  end
end

