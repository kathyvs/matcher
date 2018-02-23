require 'optparse'
class NameMatcher

  Options = Struct.new(:pattern) do

    def self.parse(args)
      raise 'Pattern is required' if args.empty?
      Options.new(Regexp.compile(args.join(' ')))
    end

    def create_matcher
      NameMatcher.new(pattern, {})
    end

    def reader
      STDIN
    end
  end

end
