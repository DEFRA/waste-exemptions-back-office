# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Text tasks", type: :rake do
  include_context "rake"

  before { allow(RenewalReminders::BulkFinalRenewalRemindersTextService).to receive(:run) }

  describe "text:renew_reminder:final:send" do
    before { subject.invoke }

    it { expect(RenewalReminders::BulkFinalRenewalRemindersTextService).to have_received(:run) }
  end

end
