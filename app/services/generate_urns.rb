# Service responsible for the generation of all urns
# It will save the set of available urns based the current URN format
# and store it in the database URNs table.
#
# The Urn model will then be able to fetch the next available unique and
# random urn for application submition
#
# Example:
#
#   Urn.next("teacher")          # => "IRPTE12345"
#   Urn.next("teacher")          # => "IRPTE12345"
#   Urn.next("salaried_trainee") # => "IRPST12345"
#
class GenerateUrns
  def self.call
    return if Urn.count.positive? # Do not override the current urn state

    Urn.transaction do
      Urn::VALID_CODES.each_value do |code|
        new(code:).generate
      end
    end
  end

  def initialize(code:)
    @code = code
  end

  attr_reader :code

  def generate
    data = unused_urns.map do |suffix|
      { prefix: Urn::PREFIX, code: code, suffix: suffix }
    end
    Urn.insert_all(data) # rubocop:disable Rails/SkipsModelValidations
  end

private

  def unused_urns
    generate_suffixes - existing_suffixes
  end

  def generate_suffixes
    Array
      .new(Urn::MAX_SUFFIX) { _1 }
      .drop(1)
      .shuffle!
  end

  def existing_suffixes
    route = Urn::VALID_CODES.key(code)
    Application
      .where(application_route: route)
      .pluck(:urn)
      .map { extract_suffix(_1) }
  end

  def extract_suffix(urn)
    urn.match(/\d+/)[0].to_i
  end
end
