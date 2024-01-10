# Create a new file - app/helpers/inflection_helper.rb
module InflectionHelper
  def pluralize_word(count, word)
    "#{count} #{word.pluralize(count)}"
  end
end