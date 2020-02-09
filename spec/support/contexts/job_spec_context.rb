# frozen_string_literal: true

shared_context "jobs" do
  # Mailer double to be returned when stubbing mailer.
  let(:mlrdbl) { double(deliver_now: nil) }

  # Runs job with nil tenant to ensure that job sets tenant itself.
  def perform_job(*args)
    ActsAsTenant.with_tenant(nil) do
      # Simulate ActiveRecord objects being reloaded in the job process.
      # This should almost always cause cluster errors unless the object is a Cluster.
      args = args.map { |a| a.is_a?(ApplicationRecord) ? a.class.find(a.id) : a }
      described_class.perform_now(*args)
    end
  end
end

shared_context "reminder jobs" do
  # Sets time to the correct hour for delivering reminders
  around do |example|
    Timecop.freeze(Time.zone.parse("2017-01-01 00:00") + Settings.reminders.time_of_day.hours) do
      example.run
    end
  end
end
