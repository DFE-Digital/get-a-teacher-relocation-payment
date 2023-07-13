# Enables or disables access to the entire application.
#
class Gatekeeper
  def self.application_open?
    return false if AppSettings.current.service_start_date.nil?
    return false if AppSettings.current.service_end_date.nil?
  end
end
