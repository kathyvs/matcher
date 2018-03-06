require 'optparse'

class NameMatcher

  DEFAULT_FILE = "oanda.db"

  module ParserBuilder

    def build_parser(result)
      OptionParser.new do |parser|
        parser.banner = "usage: name_matcher [options] PATTERN"
        file_opts(parser, result)
      end
    end

    def file_opts(parser, result)
      parser.on("-f [FILE]", "--file [FILE]") do |fname|
        fname ||= DEFAULT_FILE
        result.reader = File.open(fname, "r:ISO-8859-1:UTF-8")
      end
    end
  end

  Options = Struct.new(:reader, :pattern) do

    extend ParserBuilder

    def self.parse(args)
      options = Options.new(STDIN)
      build_parser(options).parse!(args)
      raise 'Pattern is required' if args.empty?
      options.pattern = Regexp.compile(args.join(' '))
      return options
    end

    def create_matcher
      NameMatcher.new(pattern, {})
    end

  end

end
