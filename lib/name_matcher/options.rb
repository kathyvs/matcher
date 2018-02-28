require 'optparse'
require 'pry'
class NameMatcher

  Options = Struct.new(:reader, :pattern) do

    def self.parse(args)
      options = Options.new(STDIN)
      OptionParser.new do |opts|
        opts.banner = "usage: name_matcher [options] PATTERN"

        opts.on("-fFILE", "--file=FILE") do |fname|
          options.reader = File.open(fname, "r")
        end
      end.parse!(args)
      raise 'Pattern is required' if args.empty?
      options.pattern = Regexp.compile(args.join(' '))
      return options
    end

    def create_matcher
      NameMatcher.new(pattern, {})
    end

  end

end
