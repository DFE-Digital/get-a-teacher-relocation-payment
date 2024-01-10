# Initially created to help display the correct form of day or days in the dashboard.
module InflectionHelper
  def pluralize_word(count, word)
    "#{count} #{word.pluralize(count)}"
  end
end
