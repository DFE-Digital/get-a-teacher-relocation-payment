# frozen_string_literal: true

# Urn represents a pseudo random Uniform Resource Name (URN) generator.
# Invoking the method `next` returns a unique URN with a fixed prefix
# and a random alphanumeric suffix.
#
#   Urn.configure do |c|
#     c.max_suffix = 11
#     c.seeds = { teacher: ENV['TEACHER_URN_SEED'] }
#     c.urns = ->(route) { Application.where(application_route: route).pluck(:urn) }
#   end
#
# Example:
#
#   Urn.next('teacher')          # => "IRPTE12345"
#   Urn.next('teacher')          # => "IRPTE12345"
#   Urn.next('salaried_trainee') # => "IRPST12345"
#
class Urn
  class NoUrnAvailableError < StandardError; end

  class Config
    def initialize
      @default_prefix = "IRP"
      @default_max_suffix = 99_999
      @default_codes = {
        teacher: "TE",
        salaried_trainee: "ST",
      }.with_indifferent_access
      @default_urns = ->(_) { [] }
      @mutex = Mutex.new
    end

    attr_writer :prefix, :codes, :max_suffix, :seeds, :urns, :padding_size
    attr_reader :mutex

    def prefix
      @prefix || @default_prefix
    end

    def codes
      (@codes || @default_codes).with_indifferent_access
    end

    def max_suffix
      @max_suffix || @default_max_suffix
    end

    def padding_size
      @padding_size || max_suffix.to_s.size
    end

    def seeds
      (@seeds || {}).with_indifferent_access
    end

    def urns
      @urns || @default_urns
    end
  end

  class << self
    def configure
      yield(config)
    end

    def config
      return @config if @config.present?

      @config = Config.new
    end

    def next(route)
      config.mutex.synchronize { routes[route].next }
    rescue KeyError
      raise(ArgumentError, "Invalid route: #{route}, must be one of #{config.codes.keys}")
    end

  private

    def routes
      @routes ||= Concurrent::Hash.new do |hash, route|
        hash[route] = urn_enumerator(
          config.codes.fetch(route),
          config.seeds.fetch(route, Random.new_seed),
          config.urns.call(route),
        )
      end
    end

    def urns(code, seed)
      Array
        .new(config.max_suffix) { formatter(code, _1) }
        .drop(1)
        .shuffle!(random: Random.new(seed))
    end

    def formatter(code, suffix)
      [config.prefix, code, sprintf("%0#{config.padding_size}d", suffix)].join
    end

    def available_urns(code, seed, used_urns)
      urns(code, seed) - used_urns
    end

    def urn_enumerator(code, seed, used_urns)
      list = Concurrent::Array.new(available_urns(code, seed, used_urns))
      error_msg = "you have exhausted urn for code #{code} you need to increase the size of the suffix"

      Enumerator.new do |yielder|
        list.each { yielder << _1 }

        raise(NoUrnAvailableError, error_msg)
      end
    end
  end
end
