# frozen_string_literal: true

RSpec.shared_examples "cannot mark legacy bulk or linear" do
  it { expect(subject).not_to be_able_to(:mark_as_legacy_bulk_or_linear, registration) }
end
