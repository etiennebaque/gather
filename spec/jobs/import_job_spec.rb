# frozen_string_literal: true

require "rails_helper"

# Tests the generic ImportJob class using Meals::Import
describe ImportJob do
  include_context "jobs"

  let(:community) { Defaults.community }
  let(:meal_import) { create(:meal_import, community: community, csv: "") }

  context "happy path" do
    it "calls import" do
      perform_job(class_name: "Meals::Import", id: meal_import.id)
      expect(meal_import.reload.errors_by_row).to eq("0" => ["File is empty"])
    end
  end

  context "with unhandled error" do
    it "sets crashed status and sends error notification" do
      with_env("STUB_IMPORT_ERROR" => "Unhandled error") do
        emails = email_sent_by do
          perform_job(class_name: "Meals::Import", id: meal_import.id)
        end
        expect(meal_import.reload.status).to eq("crashed")
        expect(emails[0].body.encoded).to match(/Unhandled error/)
      end
    end
  end
end
