
#
# Takes a unicode line or lines and parses the relevant portions from it.
#
class Parser

  def parse(lines)
    lines.map do |l|
      parse_line(l)
    end
  end

  protected
    def parse_line(line)
      contents = line.split('|')
      parse_items(*contents)
    end
end

class PersonalParser < Parser

  protected
    def parse_items(name, *rest)
      name
    end
end
