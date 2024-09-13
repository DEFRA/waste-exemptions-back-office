# frozen_string_literal: true

FactoryBot.define do
  factory :download, class: "Reports::Download" do
    report_type { "Reports::GeneratedReport" }
    report_file_name { "20190601-20190630.csv" }
    user_id { create(:user).id }
    downloaded_at { Time.zone.now }
  end
end
