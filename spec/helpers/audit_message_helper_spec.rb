require "rails_helper"

RSpec.describe AuditMessageHelper do
  let(:audit) do
    json_comment = nil
    json_comment = comment.to_json if comment
    build(
      :audit,
      action: action,
      user: user,
      auditable_type: auditable_type,
      comment: json_comment,
    )
  end
  let(:action) { "Something happened" }
  let(:user) { build(:user, email: "user@example.com") }
  let(:auditable_type) { "ApplicationProgress" }
  let(:comment) { nil }

  describe "audit_template" do
    subject(:audit_template) { helper.audit_template(audit) }

    context "for application progress" do
      let(:auditable_type) { "ApplicationProgress" }

      it { is_expected.to eq("application_progress") }
    end

    context "for user" do
      let(:auditable_type) { "User" }

      it { is_expected.to eq("user") }
    end

    context "for appsettings" do
      let(:auditable_type) { "AppSettings" }

      it { is_expected.to eq("app_settings") }
    end

    context "for report" do
      let(:auditable_type) { "Report" }

      it { is_expected.to eq("report") }
    end

    context "for any other entity" do
      let(:auditable_type) { "foo" }

      it { is_expected.to eq("generic") }
    end
  end

  describe "past_tense_action" do
    subject(:past_tense_action) { helper.past_tense_action(action) }

    context "when action is create" do
      let(:action) { "create" }

      it { is_expected.to eq("created") }
    end

    context "when action is update" do
      let(:action) { "update" }

      it { is_expected.to eq("updated") }
    end

    context "when action is destroy" do
      let(:action) { "destroy" }

      it { is_expected.to eq("destroyed") }
    end

    context "when action is anything else" do
      let(:action) { "something happen" }

      it { is_expected.to eq("something happen") }
    end
  end

  describe "action_colour" do
    subject(:action_colour) { helper.action_colour(action) }

    context "when action is create" do
      let(:action) { "create" }

      it { is_expected.to eq("green") }
    end

    context "when action is update" do
      let(:action) { "update" }

      it { is_expected.to eq("blue") }
    end

    context "when action is destroy" do
      let(:action) { "destroy" }

      it { is_expected.to eq("red") }
    end

    context "when action is anything else" do
      let(:action) { "something happen" }

      it { is_expected.to be_nil }
    end
  end

  describe "changed_value" do
    subject(:changed_value) { helper.changed_value(value) }

    context "when value in not blank" do
      let(:value) { "foo" }

      it { is_expected.to eq(value) }
    end

    context "when value is nil" do
      let(:value) { nil }

      it { is_expected.to eq("empty") }
    end

    context "when value is ''" do
      let(:value) { "" }

      it { is_expected.to eq("empty") }
    end
  end

  describe "display_reset_button?" do
    subject(:display_reset_button) { helper.display_reset_button?(audit) }

    let(:auditable_type) { "Report" }
    let(:user) { build(:user, email: "user@example.com", roles: [role]) }
    let(:comment) { { resettable: true } }
    let(:role) { build(:admin_role) }

    before { allow(helper).to receive(:current_user).and_return(user) }

    context "return true when feature enabled and user has role admin and report has not been reset yet" do
      before { Flipper.enable(:reset_reports) }
      after { Flipper.disable(:reset_reports) }

      it { is_expected.to be(true) }
    end

    context "return false when feature disabled" do
      before { Flipper.disable(:reset_reports) }
      after { Flipper.disable(:reset_reports) }

      it { is_expected.to be(false) }
    end

    context "return false when user not role admin" do
      let(:role) { build(:manager_role) }

      it { is_expected.to be(false) }
    end

    context "return false when report already resetted" do
      let(:comment) { { resettable: false } }

      it { is_expected.to be(false) }
    end
  end

  describe "report_name_args" do
    subject(:report_name_args) { helper.report_name_args(audit) }

    let(:comment) { { id: 1, status: nil } }

    it { is_expected.to contain_exactly(1, nil) }
  end
end
