# frozen_string_literal: true

module Applicants
  class EmploymentDetail
    include ActiveModel::Model
    attr_accessor :school_name,
                  :school_headteacher_name,
                  :school_address_line_1,
                  :school_address_line_2,
                  :school_city,
                  :school_postcode,
                  :applicant

    validates :school_name, presence: true
    validates :school_headteacher_name, presence: true
    validates :school_address_line_1, presence: true
    validates :school_city, presence: true
    validates :school_postcode, presence: true, postcode: true

    def self.build(school)
      new(
        school_name: school.name,
        school_headteacher_name: school.headteacher_name,
        school_address_line_1: school.address.address_line_1,
        school_address_line_2: school.address.address_line_2,
        school_city: school.address.city,
        school_postcode: school.address.postcode,
      )
    end

    def save!
      applicant.create_school!(
        name: school_name,
        headteacher_name: school_headteacher_name,
        address_attributes: {
          address_line_1: school_address_line_1,
          address_line_2: school_address_line_2,
          city: school_city,
          postcode: school_postcode,
        },
      )
    end
  end
end
