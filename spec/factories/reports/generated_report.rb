# frozen_string_literal: true

FactoryBot.define do
  factory :generated_report, class: "Reports::GeneratedReport" do
    file_name { "20190601-20190630.csv" }
    report_type { "bulk" }

    trait :finance_data do
      report_type { "finance_data" }
    end

    trait :boxi do
      report_type { "boxi" }
    end
  end
end
