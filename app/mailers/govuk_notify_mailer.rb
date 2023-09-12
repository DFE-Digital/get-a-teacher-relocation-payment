class GovukNotifyMailer < Mail::Notify::Mailer
  def application_submission
    @urn = params[:urn]
    view_mail(
      Rails.configuration.x.govuk_notify.mail_notify_template_id,
      to: params[:email],
      subject: t("mailer.application_submission.subject"),
    )
  end
end
