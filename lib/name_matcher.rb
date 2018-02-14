
#
# Parser for pull out personal names from the armorial
#
class PersonalExtractor

  def extract_item(item)
    name = item.name
    NameItem.new(match_name = I18n.transliterate(name), date = item.date_source,
      name = name, owner = name)
  end
end


#
# Structure for the extracted result
#
NameItem = Struct.new(:match_name, :date_source, :name, :owner)
