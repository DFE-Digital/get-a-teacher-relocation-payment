module AuditMessageHelper
  def audit_message(audit)
    method = routing_map[audit.auditable_type] || :generic_audit_message
    message = send(method, audit)
    message += "#{timestamp(audit)} (#{time_ago_in_words(audit.created_at)} ago)"
    message.html_safe # rubocop:disable Rails/OutputSafety
  end

private

  def routing_map
    {
      "ApplicationProgress" => :application_progress_audit_message,
      "User" => :user_audit_message,
      "AppSettings" => :app_settings_audit_message,
    }
  end

  def application_progress_audit_message(audit)
    email_tag = govuk_tag(text: audit.user&.email || "unknown", colour: "grey")
    urn_text = govuk_link_to(audit.auditable&.application&.urn, applicant_path(audit.auditable&.application&.applicant))
    urn_tag = govuk_tag(text: urn_text, colour: "orange")
    "#{email_tag} #{action_tag(audit)} application progress #{urn_tag}.</br>It changed: <ul>#{audited_changes_summary(audit)}</ul>"
  end

  def app_settings_audit_message(audit)
    email_tag = govuk_tag(text: audit.user&.email || "unknown", colour: "grey")
    "#{email_tag} #{action_tag(audit)} application settings.</br>It changed: <ul>#{audited_changes_summary(audit)}</ul>"
  end

  def user_audit_message(audit)
    email_tag = govuk_tag(text: audit.user&.email || "unknown", colour: "grey")
    case audit.action
    when "create"
      "#{email_tag} #{action_tag(audit)} a new User entity #{govuk_tag(text: audit.audited_changes['email'], colour: 'yellow')}"
    when "update"
      "#{email_tag} #{action_tag(audit)} User entity.</br>It changed: <ul>#{audited_changes_summary(audit)}</ul>"
    when "destroy"
      "#{email_tag} #{action_tag(audit)} User entity #{govuk_tag(text: audit.audited_changes['email'], colour: 'yellow')}<br />"
    end
  end

  def generic_audit_message(audit)
    email_tag = govuk_tag(text: audit.user&.email || "unknown", colour: "grey")
    "#{email_tag} #{action_tag(audit)}<br />"
  end

  def audited_changes_summary(audit)
    audit.audited_changes.except("status").map { |key, value|
      "<li>#{key} (from: \"#{changed_value(value.first)}\", to: \"#{changed_value(value.last)}\")</li>"
    }.join
  end

  def timestamp(audit)
    govuk_tag(text: audit.created_at.strftime("%d/%m/%Y %H:%M:%S"), colour: "grey")
  end

  def action_tag(audit)
    govuk_tag(text: past_tense_action(audit.action), colour: action_colour(audit.action))
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

  def changed_value(value)
    return "&lt;empty&gt;" if value.nil?
    return "&lt;empty&gt;" if value.blank?

    value
  end
end
