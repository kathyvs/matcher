
#
# Parser for pull out personal names from the armorial
#
class PersonalExtractor

  def extract_item(name, date, *unused)
    NameItem.new(match_name = I18n.transliterate(name), date = date_source, name = name, owner = name)
  end
end


#
# Structure for the extracted result
#
NameItem = Struct.new(:match_name, :date, :name, :owner)
