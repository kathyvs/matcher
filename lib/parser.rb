require 'pry'
require 'i18n'

I18n.enforce_available_locales = false
#
# Takes a unicode line or lines and parses the relevant portions from it.
#
class Parser

  KINGDOM_CODES = {
    'H' => '\u0036thelmearc',
    'N' => 'An Tir',
    'X' => 'Ansteorra',
    'R' => 'Artemisia',
    'A' => 'Atenveldt',
    'Q' => 'Atlantia',
    'V' => 'Avacal',
    'C' => 'Caid',
    'K' => 'Calontir',
    'D' => 'Drachenwald',
    'm' => 'Ealdormere',
    'E' => 'East',
    't' => 'Gleann Abhann',
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
    end.collect!
  end

  protected

    def parse_line(line)
      contents = line.split('|')
      name, date, type, ref = contents
      date = date_parser.parse(date)
      parse_items(name, date, type, ref) if date
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
      date = Date.new(year = year.to_i, month=month.to_i)
      kingdom = kingdom_map.fetch(kingdom_code)
      DateSource.new(date=date, kingdom=kingdom)
    end
  end

end

#
# Parser for pull out personal names from the armorial
#
class PersonalParser < Parser

  protected
    def parse_items(name, date, *unused)
      NameItem.new(match_name = I18n.transliterate(name), date = date, name = name, owner = name)
    end
end

#
# Structure for the parsed result
#
NameItem = Struct.new(:match_name, :date, :name, :owner)

#
# Date the submission was registered
#
DateSource = Struct.new(:date, :kingdom)

