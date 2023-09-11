require "rails_helper"

RSpec.describe "Schedule jobs" do
  subject(:schedule_jobs) { YAML.load_file(schedule_file_path) }

  let(:schedule_file_path) { "config/schedule.yml" }

  it "config file exists" do
    expect(schedule_jobs).to be_present
  end

  describe DeleteStaleFormsJob do
    let(:job_name) { "delete_stale_forms" }
    let(:job) { schedule_jobs[job_name] }

    it "schedule time" do
      expect(job["cron"]).to eq("0 1 * * *")
    end

    it "job class name" do
      expect(job["class"]).to eq(described_class.name)
    end
  end
end
