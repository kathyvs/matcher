require 'name_matcher/options'
require 'pry'

describe "Options" do

  it 'treats non-flag options as the pattern' do
    options = NameMatcher::Options.parse(["A", "B*"])
    expect(options.pattern).to eq(/A B*/)
  end

  it 'requires at least one non-flag option' do
    expect {
      NameMatcher::Options.parse([])
    }.to raise_error(/pattern.*required/i)
  end

  it 'creates a reader from STDIN (TODO: change to a file by default)' do
    options = NameMatcher::Options.parse(["A"])
    expect(options.reader).to be(STDIN)
  end
end
