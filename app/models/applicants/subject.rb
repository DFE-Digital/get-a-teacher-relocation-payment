# frozen_string_literal: true

module Applicants
  class Subject
    include ActiveModel::Model
    attr_accessor :subject

    SUBJECT_OPTIONS = %w[physics languages other].freeze

    validates :subject, presence: true, inclusion: { in: SUBJECT_OPTIONS }

    def eligible?
      subject != "other"
    end
  end
end
