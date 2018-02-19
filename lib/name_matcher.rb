require 'parser'
require 'extractor'

module NameMatcher

  #
  # Runs the matching pipeline from an input of lines of string
  # To an output of formatted lines of string
  #
  class Runner

    attr_reader :match_pattern, :parser, :extractor

    def initialize(match_pattern, options)
      @match_pattern = match_pattern
      @parser = options[:parser] || NameMatcher::Parser.new
      @extractor = options[:extractor] || NameMatcher::PersonalExtractor.new
    end

    def run(reader)
      lines = reader.readlines.lazy
      parsed_items = parser.parse(lines)
      match_items = map_select(parsed_items, extractor.method(:extract_item)).lazy
      match_items.select {|item| match(item)}.map(&:display)
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
        match_pattern =~ item.match_name
      end

  end

end
