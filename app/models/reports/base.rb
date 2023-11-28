module Reports
  class Base
    def initialize(**kwargs)
      @kwargs = kwargs
      @name = self.class.name.titleize.tr(" /", "-").downcase
    end

    attr_reader :name, :kwargs

    class << self
      def file_ext(value)
        @file_ext = value
      end

      def get_file_ext
        @file_ext || "csv"
      end
    end

    def filename
      current_time = Time.zone.now.strftime("%Y%m%d-%H%M%S")

      "#{name}-#{current_time}.#{self.class.get_file_ext}"
    end

    def generate; end

    def post_generation_hook; end

    def reset; end

    def timestamp
      kwargs&.fetch(:timestamp, nil)
    end

  private

    def timestamp_range
      return unless timestamp

      t = Time.zone.parse(timestamp)
      Range.new(t - 1.second, t + 1.second)
    end
  end
end
