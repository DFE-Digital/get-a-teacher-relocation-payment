require "rails_helper"

RSpec.describe AuditMessageHelper do
  include ActiveSupport::Testing::TimeHelpers

  describe "#audit_message" do
    let(:user) { build(:user, email: "user@example.com") }
    let(:timestamp) { "10/09/2023 12:00:00" }

    context "a generic audit" do
      let(:audit) { build(:audit, action: "generic audit message", user: user, created_at: Time.zone.parse(timestamp)) }

      it "includes the auditee email" do
        expect(helper.audit_message(audit)).to include("user@example.com")
      end

      it "includes the action text" do
        expect(helper.audit_message(audit)).to include("generic audit message")
      end

      it "includes the timestamp" do
        expect(helper.audit_message(audit)).to include(timestamp)
      end
    end

    context "an audit for a user action" do
      let(:audit) { build(:audit, action: action, user: user, auditable: user, audited_changes: { "email" => ["otheruser@example.com", "other-user@example.com"] }, created_at: Time.zone.parse(timestamp)) }

      describe "create" do
        let(:action) { "create" }

        it "includes the auditee email" do
          expect(helper.audit_message(audit)).to include("user@example.com")
        end

        it "includes the action text" do
          expect(helper.audit_message(audit)).to include("created")
        end

        it "includes the entity name" do
          expect(helper.audit_message(audit)).to include("User entity")
        end

        it "includes the user email" do
          expect(helper.audit_message(audit)).to include("otheruser@example.com")
        end

        it "includes the timestamp" do
          expect(helper.audit_message(audit)).to include(timestamp)
        end
      end

      describe "update" do
        let(:action) { "update" }

        it "includes the auditee email" do
          expect(helper.audit_message(audit)).to include("user@example.com")
        end

        it "includes the action text" do
          expect(helper.audit_message(audit)).to include("updated")
        end

        it "includes the entity name" do
          expect(helper.audit_message(audit)).to include("User entity")
        end

        it "includes the user email changes" do
          expect(helper.audit_message(audit)).to include("otheruser@example.com")
          expect(helper.audit_message(audit)).to include("other-user@example.com")
        end

        it "includes the timestamp" do
          expect(helper.audit_message(audit)).to include(timestamp)
        end
      end

      describe "destroy" do
        let(:action) { "destroy" }

        it "includes the auditee email" do
          expect(helper.audit_message(audit)).to include("user@example.com")
        end

        it "includes the action text" do
          expect(helper.audit_message(audit)).to include("destroyed")
        end

        it "includes the entity name" do
          expect(helper.audit_message(audit)).to include("User entity")
        end

        it "includes the user email" do
          expect(helper.audit_message(audit)).to include("otheruser@example.com")
        end

        it "includes the timestamp" do
          expect(helper.audit_message(audit)).to include(timestamp)
        end
      end
    end

    context "an audit for an application action" do
      let(:application) { create(:application) }
      let(:progress) { build(:application_progress, application:) }
      let(:audit) { build(:audit, action: "update", user: user, auditable: progress, audited_changes: { "school_checks_completed_at" => ["", "2023-08-25"], "banking_approval_completed_at" => %w[2023-08-25 2023-09-10] }, created_at: Time.zone.parse(timestamp)) }

      it "includes the auditee email" do
        expect(helper.audit_message(audit)).to include("user@example.com")
      end

      it "includes the action text" do
        expect(helper.audit_message(audit)).to include("updated")
      end

      it "includes the entity name" do
        expect(helper.audit_message(audit)).to include("application progress")
      end

      it "includes the entity id link" do
        expect(helper.audit_message(audit)).to include("/applicants/#{application.applicant_id}")
      end

      context "includes the changes" do
        it "from empty field" do
          expect(helper.audit_message(audit)).to include("school_checks_completed_at")
          expect(helper.audit_message(audit)).to include("&lt;empty&gt;")
        end

        it "from non-empty field" do
          expect(helper.audit_message(audit)).to include("banking_approval_completed_at")
          expect(helper.audit_message(audit)).to include("2023-08-25")
          expect(helper.audit_message(audit)).to include("2023-09-10")
        end
      end

      it "includes the timestamp" do
        expect(helper.audit_message(audit)).to include(timestamp)
      end
    end

    context "an audit for an app settings action" do
      let(:audit) { build(:audit, action: "update", user: user, auditable_type: "AppSettings", audited_changes: { "service_start_date" => %w[2022-09-01 2023-08-25] }, created_at: Time.zone.parse(timestamp)) }

      it "includes the auditee email" do
        expect(helper.audit_message(audit)).to include("user@example.com")
      end

      it "includes the action text" do
        expect(helper.audit_message(audit)).to include("updated")
      end

      it "includes the entity name" do
        expect(helper.audit_message(audit)).to include("application settings")
      end

      it "includes the changes" do
        expect(helper.audit_message(audit)).to include("2022-09-01")
        expect(helper.audit_message(audit)).to include("2023-08-25")
        expect(helper.audit_message(audit)).to include("service_start_date")
      end

      it "includes the timestamp" do
        expect(helper.audit_message(audit)).to include(timestamp)
      end
    end
  end
end
