require "rails_helper"

RSpec.describe "Smoke test", smoke_test: true do
  it "runs" do
    visit(ENV.fetch("SMOKE_URL"))
    expect(page).to have_text("Get an international relocation payment")
  end
end
