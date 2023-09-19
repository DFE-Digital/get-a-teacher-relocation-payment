# frozen_string_literal: true

# Urn represents a Uniform Resource Name (URN) generator.
# It generates a URN with a fixed prefix and suffix created from UUID
# converted to based 8 to only contain digits.
#
# Suffix Algo base 8:
# generate a UUID
# remove any '-' chars
# convert to a binary string
# prepend some padding when necessary
# split in groups of 3 bits, each group is a one char in base 8; from "000" to "111"
# convert each group to a char in base 10; from "0" to "7" => CHARSET
# map each char to the CHARSET
#
# original idea: https://www.fastruby.io/blog/ruby/uuid/friendlier-uuid-urls-in-ruby.html
#
# Example:
#
# Urn.call("teacher", base: 8)  => "IRPTE1534743322003655447026533317435036675213160"
# Urn.call("teacher", base: 16) => "IRPTEA8B252DB88114FCB991BF6763262CD04"
# Urn.call("teacher", base: 32) => "IRPTE13MVE7PCVHKP5S5BQDC47KK2IQ"
# Urn.call("teacher", base: 64) => "IRPTEBJ_8UdgBaxHZo9QRxawrn

class Urn
  # rubocop:disable Layout/MultilineArrayLineBreaks
  CHARSET = %w[
    0 1 2 3 4 5 6 7 8 9
    A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
    a b c d e f g h i j k l m n o p q r s t u v w x y z
    - _
  ].freeze
  # rubocop:enable Layout/MultilineArrayLineBreaks

  PREFIX = "IRP"
  TEACHER_ROUTE = "teacher"
  TRAINEE_ROUTE = "salaried_trainee"
  ROUTE_MAPPING = {
    TEACHER_ROUTE => "TE",
    TRAINEE_ROUTE => "ST",

  }.freeze
  ACCEPTED_BASES = [8, 16, 32, 64].freeze

  def self.call(...)
    service = new(...)
    service.generate_suffix
    service.urn
  end

  def initialize(route, prefix: PREFIX, route_mapping: ROUTE_MAPPING, base: ACCEPTED_BASES.last)
    @base = base
    raise(ArgumentError, "base must be one of #{ACCEPTED_BASES}") unless ACCEPTED_BASES.include?(base)

    @prefix = prefix
    @code = route_mapping.fetch(route)
    @bit_group_size = (base - 1).to_s(2).size
  rescue KeyError
    raise(ArgumentError, "invalid route #{route}. Must be one of #{ROUTE_MAPPING.keys}")
  end

  def urn
    [prefix, code, suffix].join
  end

  def generate_suffix
    @suffix = (
      method(:binary_coded_decimal) >>
      method(:prepend_padding) >>
      method(:to_base) >>
      method(:charset_encode)
    ).call(compact_uuid)
  end

private

  attr_reader :prefix, :code, :suffix, :base, :bit_group_size

  def compact_uuid
    SecureRandom.uuid.tr("-", "")
  end

  def binary_coded_decimal(uuid)
    uuid.chars.map { |c| c.hex.to_s(2).rjust(4, "0") }.join
  end

  def prepend_padding(str)
    char_offset = str.size % bit_group_size
    return str if char_offset.zero?

    padding = "0" * (bit_group_size - char_offset)
    padding + str
  end

  def to_base(str)
    regex = %r(.{#{bit_group_size}})
    str
      .scan(regex)
      .map { |x| x.to_i(2) }
  end

  def charset_encode(str)
    str.map { |x| CHARSET.fetch(x) }
  end
end
