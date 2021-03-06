require 'date'

class NameMatcher

  #
  # Takes a unicode line or lines and parses the relevant portions from it.
  #
  class Parser

    KINGDOM_CODES = {
      'H' => "\u00C6thelmearc",
      'N' => 'An Tir',
      'X' => 'Ansteorra',
      'R' => 'Artemisia',
      'A' => 'Atenveldt',
      'Q' => 'Atlantia',
      'V' => 'Avacal',
      'C' => 'Caid',
      'G' => 'Gleann Abhann',
      'K' => 'Calontir',
      'D' => 'Drachenwald',
      'm' => 'Ealdormere',
      'E' => 'East',
      'L' => 'Laurel',
      'w' => 'Lochac',
      'S' => 'Meridies',
      'M' => 'Middle',
      'n' => 'Northshield',
      'O' => 'Outlands',
      'T' => 'Trimaris',
      'W' => 'West'
    }

    def date_parser
      @date_parser ||= DateParser.new
    end

    def parse(lines)
      lines.map do |line|
        parse_line(line)
      end.select {|item| item}
    end

    protected

      def parse_line(line)
        contents = line.split('|')
        name, date_code, type, ref = contents
        date = date_parser.parse(date_code)
        ParsedItem.new(name, date, type, ref) if date
      end

    #
    # Parser to convert the strong format YYYYMMK to date and kingdom
    #
    class DateParser

      PATTERN = /^([12][0-9][0-9][0-9])([01][0-9])([A-Za-z])$/

      def kingdom_map
        @kingdom_map ||= KINGDOM_CODES
      end

      def parse(date_str)
        match_data = PATTERN.match(date_str)
        return nil unless match_data
        _, year, month, kingdom_code = match_data.to_a
        DateSource.new(Date.new(year = year.to_i, month=month.to_i),
          kingdom_map.fetch(kingdom_code, kingdom_code))
      end
    end

    #
    # Parsed structure
    #
    ParsedItem = Struct.new(:name, :date_source, :type, :text)

    #
    # Date the submission was registered along with the kingdom.
    #
    class DateSource < Struct.new(:date, :kingdom)

      def display
        "#{kingdom}, #{date.strftime('%B %-d, %Y')}"
      end
    end

end
end

