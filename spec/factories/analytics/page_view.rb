# frozen_string_literal: true

FactoryBot.define do
  factory :page_view, class: "WasteExemptionsEngine::Analytics::PageView" do
    page { "MyString" }
    time { Time.zone.now }
    route { "MyString" }
    user_journey { nil }
  end
end
