module AuditMessageHelper
  # rubocop:disable Layout/HashAlignment
  TEMPLATE_MAP = {
    "ApplicationProgress" => "application_progress",
    "User"                => "user",
    "AppSettings"         => "app_settings",
    "Report"              => "report",
  }.freeze
  # rubocop:enable Layout/HashAlignment

  def audit_template(audit)
    TEMPLATE_MAP.fetch(audit.auditable_type, "generic")
  end

  def past_tense_action(action)
    {
      "create" => "created",
      "update" => "updated",
      "destroy" => "destroyed",
    }[action] || action
  end

  def action_colour(action)
    {
      "create" => "green",
      "update" => "blue",
      "destroy" => "red",
    }[action]
  end

  def display_reset_button?(audit)
    return false if audit.comment.blank?

    comment = JSON.parse(audit.comment)

    Flipper.enabled?(:reset_reports) &&
      current_user.has_role?(:admin) &&
      comment.fetch("resettable", false)
  rescue StandardError
    false
  end

  def report_name_args(audit)
    comment = JSON.parse(audit.comment)

    [comment.fetch("id"), comment.fetch("status")]
  end

  def changed_value(value)
    return "empty" if value.blank?

    value
  end
end
