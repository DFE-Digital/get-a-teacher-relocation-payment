# frozen_string_literal: true

# Controls access to the application. The application is open when the current
# date is between the start and end of the service. The start and end of the
# service are configurable via the AppSettings model.
#
class Gatekeeper
  def self.application_open?
    return false if AppSettings.current.service_start_date.nil?
    return false if AppSettings.current.service_end_date.nil?

    Date.current.between?(
      AppSettings.current.service_start_date,
      AppSettings.current.service_end_date,
    )
  end
end
