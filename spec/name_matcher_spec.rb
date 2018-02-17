require 'rspec'
require 'name_matcher'
require 'pry'
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

  let(:displayer) {
    TestDisplayer.new
  }

  let(:output) {
    StringIO.new
  }

  def run_matcher(pat, input)
    allow(reader).to receive(:read).and_return(input.to_enum)
    allow(extractor)
    name_matcher(pat).run(reader)
  end

  def name_matcher(pat)
    options = {parser: parser, extractor: extractor,
      displayer: displayer, output: output
    }
    NameMatcher::Runner.new(pat, options)
  end

  it "filters from the reader to output" do
    input = ["1", "x", "2", "11", "4", "51", "-12"]
    pat = /1/
    run_matcher(pat, input)
    expect(output.string).to include("|1|", "|11|", "|51|")
    expect(output.string).to_not include("2", "4", "-", "10")
  end

  it "works with real pipeline classes"
end

class TestParser

  def parse(lines)
    lines.map(&:to_i).select {|i| i != 0}
  end
end

class TestExtractor

  def extract(item)
    item > 0 ? Item.new(item.to_s, item) : nil
  end
end

Item = Struct.new(:match_name, :value)

class TestDisplayer

  def display(item)
    "|#{item.value}|"
  end
end
