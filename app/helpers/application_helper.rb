# frozen_string_literal: true

module ApplicationHelper
  def link_to_irp(name = "international relocation payment (IRP)")
    govuk_link_to(
      name,
      "https://www.gov.uk/government/publications/international-relocation-payments/international-relocation-payments",
      { target: "_blank" },
    )
  end

  def mailto_teach_in_england
    govuk_link_to("teach.inengland@education.gov.uk", "mailto:teach.inengland@education.gov.uk")
  end

  def mailto_irp_express_interest
    govuk_link_to("irp.expressinterest@education.gov.uk", "mailto:IRP.ExpressInterest@education.gov.uk")
  end

  def banner_feedback_form
    govuk_link_to("feedback", "https://forms.office.com/e/p45Wm1Vmxg", target: "_blank")
  end
end
