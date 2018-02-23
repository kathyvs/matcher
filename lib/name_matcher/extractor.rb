
require 'i18n'

class NameMatcher

  #
  # Parser for pull out personal names from the armorial
  #
  class PersonalExtractor
    FOR_PATTERN = /^for\s(.*)/i

    def extract_item(item)
      case item.type
      when 'AN'
        match = FOR_PATTERN.match(item.text)
        owner = match ? match[1] : item.text
        NameItem.new(item.name, item.date_source, owner)
      when /^[BDN]$/
        NameItem.new(item.name, item.date_source, item.name)
      end
    end
  end


  #
  # Structure for the extracted result
  #
  NameItem = Struct.new(:name, :date_source, :owner) do
    I18n.enforce_available_locales = false

    def match_name
      @match_name ||= normalize(name)
    end

    def display
      owner_tag = owner == name ? "" : ", for #{owner}"
      "#{name} (#{date_source.display})#{owner_tag}"
    end

    private

      def normalize(string)
        I18n.transliterate(string)
      end
  end

end
