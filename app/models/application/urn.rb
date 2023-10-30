#
# build a pseudo random urns list with the existing urns removed from that list
# and we calculate the global index of the current application based on list sorted by created_at
# then we get the urn located at the determined application index
#

class Application::Urn
  class << self
    def reset_urns
      const_set(:URNS, build_urns)
      nil
    end

    def build_urns
      {
        "teacher" => build_list("TE"),
        "salaried_trainee" => build_list("ST"),
      }.freeze
    end

    def build_list(code)
      su_size = LENGTH.to_s.size
      Array
        .new(LENGTH) { [PREFIX, code, sprintf("%0##{su_size}d", _1)].join }
        .drop(1)
        .shuffle!
    end
  end

  LENGTH = 99_999
  PREFIX = "IRP".freeze
  URNS = build_urns

  def initialize(application)
    @application = application
  end

  def urn
    MUTEX.synchronize do
      increase_suffix if urns_exhausted?
      available_urns[application_index]
    end
  end

private

  def increase_suffix
    self.class.const_set(:LENGTH, "#{self.class::LENGTH}9".to_i)
    self.class.reset_urns
  end

  def urns_exhausted?
    application_index > available_urns.size
  end

  def application_index
    return @application_index if @application_index

    @application_index = FindApplicationIndexQuery
      .new(application_id: @application.id)
      .execute
      .to_a
      .dig(0, "application_index")

    raise(ArgumentError, "application not found") unless @application_index

    @application_index -= 1 # FindApplicationIndexQuery returns a index starting at 1
    @application_index -= used_urns.size # removes the existing applications to have a correct index
    @application_index
  end

  def available_urns
    @available_urns ||= URNS.fetch(@application.application_route) - used_urns
  end

  def used_urns
    @used_urns ||= Application.where(application_route: @application.application_route).pluck(:urn)
  end

  MUTEX = Mutex.new
end
