module Reports
  class Base
    def initialize(**kwargs)
      @kwargs = kwargs
      @name = self.class.name.titleize.tr(" /", "-").downcase
    end

    attr_reader :name, :kwargs

    def filename
      current_time = Time.zone.now.strftime("%Y%m%d-%H%M%S")

      "#{name}-#{current_time}.csv"
    end

    def csv; end

    def post_generation_hook; end
  end
end
