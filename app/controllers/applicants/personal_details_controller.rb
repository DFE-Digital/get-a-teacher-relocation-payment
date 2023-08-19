# frozen_string_literal: true

module Applicants
  class PersonalDetailsController < ApplicationController
    invisible_captcha only: %i[create], honeypot: :username
    before_action :check_application!

    def new
      @personal_detail = PersonalDetail.new(applicant: current_application.applicant)
    end

    def create
      @personal_detail = PersonalDetail.new(personal_detail_params)

      if @personal_detail.valid?
        @personal_detail.save!(application: current_application)

        redirect_to(new_applicants_employment_detail_path)
      else
        render(:new)
      end
    end

  private

    def personal_detail_params
      params.require(:applicants_personal_detail).permit(
        :given_name,
        :middle_name,
        :family_name,
        :email_address,
        :phone_number,
        :sex,
        :passport_number,
        :nationality,
        :address_line_1,
        :address_line_2,
        :city,
        :postcode,
        *DOB_CONVERSION.keys,
      ).transform_keys do |key|
        DOB_CONVERSION.key?(key) ? DOB_CONVERSION[key] : key
      end
    end

    DOB_CONVERSION = {
      "date_of_birth(3i)" => "day",
      "date_of_birth(2i)" => "month",
      "date_of_birth(1i)" => "year",
    }.freeze
    private_constant :DOB_CONVERSION
  end
end
