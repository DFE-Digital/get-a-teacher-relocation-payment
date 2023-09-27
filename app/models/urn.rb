# == Schema Information
#
# Table name: urns
#
#  id         :bigint           not null, primary key
#  code       :string
#  prefix     :string
#  suffix     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
#   Urn.next('teacher')          # => "IRPTE12345"
#   Urn.next('teacher')          # => "IRPTE12345"
#   Urn.next('salaried_trainee') # => "IRPST12345"
#

class Urn < ApplicationRecord
  class NoUrnAvailableError < StandardError; end

  PREFIX = "IRP".freeze
  MAX_SUFFIX = 99_999
  PADDING_SIZE = MAX_SUFFIX.to_s.size
  VALID_CODES = {
    "teacher" => "TE",
    "salaried_trainee" => "ST",
  }.freeze

  def self.next(route)
    code = VALID_CODES.fetch(route)
    Urn.transaction do
      urn = find_by!(code:)
      urn.destroy!
      urn.to_s
    end
  rescue KeyError => e
    Sentry.capture_exception(e)
    raise(ArgumentError, "Unknown route #{route}")
  rescue ActiveRecord::RecordNotFound => e
    Sentry.capture_exception(e)
    raise(NoUrnAvailableError, "There no more unique URN available for #{route}")
  end

  def to_s
    [prefix, code, sprintf("%0#{PADDING_SIZE}d", suffix)].join
  end
end
