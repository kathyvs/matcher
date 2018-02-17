require 'pry'

module NameMatcher

  class Runner

    attr_reader :match_pattern, :parser, :extractor, :displayer, :output

    def initialize(match_pattern, options)
      @match_pattern = match_pattern
      @parser = options[:parser] || 3
      @extractor = options[:extractor] || 5
      @displayer = options[:displayer] || 3
      @output = options[:output] || 3
    end

    def run(reader)
      lines = reader.read.lazy
      parsed_items = parser.parse(lines)
      match_items = map_select(parsed_items, extractor.method(:extract))
      matched_items = match_items.select {|item| match(item)}
      matched_items.each do |item|
        output << displayer.display(item)
        output << "\n"
      end
    end

    private

      def map_select(enum, filter)
        return enum_for(:map_select, enum, filter) unless block_given?
        enum.each do |item|
          result = filter.call(item)
          yield result if result
        end
      end

      def match(item)
        binding.pry
        match_pattern =~ item.match_name
      end

  end

end
