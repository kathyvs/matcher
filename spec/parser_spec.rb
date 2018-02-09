require 'rspec'
require 'parser'

describe 'Parser' do

  def parse_line(line)
    send(:parser).parse([line]).to_a[0]
  end

  context "When parsing dates"

  context "When searching for personal names" do

    let (:parser) {
      PersonalParser.new
    }

    it "Pulls out the first element in the normal case" do
      line = "East Kingdom|197908E|Bv|East, Kingdom of the|(regid:30175)"
      result = parse_line(line)
      expect(result).to eq("East Kingdom")
    end
  end

  context "When searching for non personal names"
end
