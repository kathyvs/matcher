require 'name_matcher/options'

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

  def set_buffer(file_name, contents)
    buffer = StringIO.new(contents)
    allow(File).to receive(:open).with(file_name, /r/).and_return(buffer)
  end

  context "for the file flag" do

    let (:file_name) {
      "test.db"
    }

    ['-f', '--file'].each do |flag|
      it "creates a reader from a file if the #{flag} is set with a value" do
        file_name = "test.db"
        contents = "test-contents";
        set_buffer(file_name, contents)
        options = NameMatcher::Options.parse(["A", flag, file_name])
        expect(options.reader).to_not be(STDIN)
        expect(options.reader.read).to eq(contents);
      end

      it "uses #{NameMatcher::DEFAULT_FILE} if #{flag} is given without a parameter" do
        contents = "test-contents-oanda"
        set_buffer(NameMatcher::DEFAULT_FILE, contents)
        options = NameMatcher::Options.parse(["A", flag])
        expect(options.reader.read).to eq(contents);
        #expect {
        #  NameMatcher::Options.parse(["A", flag])
        #}.to raise_error(OptionParser::MissingArgument)
      end

      it "gives an error if #{flag} is set to a missing file" do
        expect {
          NameMatcher::Options.parse(["A", flag, "XXX"])
        }.to raise_error(/no such file/i)
      end
    end
  end
end
