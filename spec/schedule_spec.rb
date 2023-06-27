# frozen_string_literal: true

require "rails_helper"
require "whenever/test"
require "open3"

# This allows us to ensure that the schedules we have declared in whenever's
# (https://github.com/javan/whenever) config/schedule.rb are valid.
# The hope is this saves us from only being able to confirm if something will
# work by actually running the deployment and seeing if it breaks (or not)
# See https://github.com/rafaelsales/whenever-test for more details

RSpec.describe "Whenever::Test::Schedule" do
  let(:schedule) { Whenever::Test::Schedule.new(file: "config/schedule.rb") }

  it "makes sure 'rake' statements exist" do
    rake_jobs = schedule.jobs[:rake]
    expect(rake_jobs.count).to eq(12)

    epr_jobs = rake_jobs.select { |j| j[:task] == "reports:export:epr" }
    bulk_jobs = rake_jobs.select { |j| j[:task] == "reports:export:bulk" }
    expect(epr_jobs.count).to eq(1)
    expect(bulk_jobs.count).to eq(1)
  end

  it "picks up the EPR export run frequency and time" do
    job_details = schedule.jobs[:rake].find { |h| h[:task] == "reports:export:epr" }

    expect(job_details[:every][0]).to eq(:day)
    expect(job_details[:every][1][:at]).to eq("22:05")
  end

  it "takes the area lookup execution time from the appropriate ENV variable" do
    job_details = schedule.jobs[:rake].find { |h| h[:task] == "lookups:update:missing_easting_and_northing" }

    expect(job_details[:every][0]).to eq(:day)
    expect(job_details[:every][1][:at]).to eq("23:05")
  end

  it "picks up the area lookup run frequency and time" do
    job_details = schedule.jobs[:rake].find { |h| h[:task] == "lookups:update:missing_area" }

    expect(job_details[:every][0]).to eq(:day)
    expect(job_details[:every][1][:at]).to eq("01:05")
  end

  it "picks up the bulk export run frequency and time" do
    job_details = schedule.jobs[:rake].find { |h| h[:task] == "reports:export:bulk" }

    expect(job_details[:every][0]).to eq(:day)
    expect(job_details[:every][1][:at]).to eq("02:05")
  end

  it "can determine the configured cron log output path" do
    expected_output_file = File.join("/srv/ruby/waste-exemptions-back-office/shared/log/", "whenever_cron.log")
    expect(schedule.sets[:output]).to eq(expected_output_file)
  end

  it "picks up the first email reminder run frequency and time" do
    job_details = schedule.jobs[:rake].find { |h| h[:task] == "email:renew_reminder:first:send" }

    expect(job_details[:every][0]).to eq(:day)
    expect(job_details[:every][1][:at]).to eq("02:05")
  end

  it "picks up the second email reminder run frequency and time" do
    job_details = schedule.jobs[:rake].find { |h| h[:task] == "email:renew_reminder:second:send" }

    expect(job_details[:every][0]).to eq(:day)
    expect(job_details[:every][1][:at]).to eq("04:05")
  end

  it "picks up the final text reminder run frequency and time" do
    job_details = schedule.jobs[:rake].find { |h| h[:task] == "text:renew_reminder:final:send" }

    expect(job_details[:every][0]).to eq(:day)
    expect(job_details[:every][1][:at]).to eq("10:00")
  end

  it "picks up the expire registration exemption run frequency and time" do
    job_details = schedule.jobs[:rake].find { |h| h[:task] == "expire_registration:run" }

    expect(job_details[:every][0]).to eq(:day)
    expect(job_details[:every][1][:at]).to eq("00:05")
  end

  it "picks up the Notify AD renewal letters run frequency and time" do
    job_details = schedule.jobs[:rake].find { |h| h[:task] == "notify:letters:ad_renewals" }

    expect(job_details[:every][0]).to eq(:day)
    expect(job_details[:every][1][:at]).to eq("02:35")
  end

  it "picks up the boxi export generation run frequency and time" do
    job_details = schedule.jobs[:rake].find { |h| h[:task] == "reports:export:boxi" }

    expect(job_details[:every][0]).to eq(:day)
    expect(job_details[:every][1][:at]).to eq("03:05")
  end

  it "picks up the transient registration cleanup execution run frequency and time" do
    job_details = schedule.jobs[:rake].find { |h| h[:task] == "cleanup:transient_registrations" }

    expect(job_details[:every][0]).to eq(:day)
    expect(job_details[:every][1][:at]).to eq("00:35")
  end

  it "picks up the cleanup:remove_expired_registrations run frequency and time" do
    job_details = schedule.jobs[:rake].find { |h| h[:task] == "cleanup:remove_expired_registrations" }

    expect(job_details[:every][0]).to eq(:day)
    expect(job_details[:every][1][:at]).to eq("00:45")
  end

  it "allows the `whenever` command to be called without raising an error" do
    Open3.popen3("bundle", "exec", "whenever") do |_, stdout, stderr, wait_thr|
      expect(stdout.read).not_to be_empty
      expect(stderr.read).to be_empty
      expect(wait_thr.value.success?).to be(true)
    end
  end
end
