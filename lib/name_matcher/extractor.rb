
require 'i18n'

module NameMatcher
  #
  # Parser for pull out personal names from the armorial
  #
  class PersonalExtractor
    I18n.enforce_available_locales = false

    def extract_item(item)
      name = item.name
      NameItem.new(match_name = I18n.transliterate(name), date = item.date_source,
        name = name, owner = name)
    end
  end


  #
  # Structure for the extracted result
  #
  class NameItem < Struct.new(:match_name, :date_source, :name, :owner)

    def display
      "#{name} (#{date_source.display})"
    end
  end

end