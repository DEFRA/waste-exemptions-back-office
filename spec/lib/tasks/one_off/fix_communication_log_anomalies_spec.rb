# frozen_string_literal: true

require "rails_helper"

RSpec.describe "one_off:fix_communication_log_anomalies", type: :rake do

  subject(:run_rake_task) { rake_task.invoke }

  include_context "rake"

  describe "#fix_communication_log_anomalies" do
    let(:rake_task) { Rake::Task["one_off:fix_communication_log_anomalies"] }
    let(:notify_confirmation_letter_id) { "81cae4bd-9f4c-4e14-bf3c-44573cee4f5b" }
    let(:registration_edit_link_email_id) { "09320726-38c6-4989-a831-17c7d4ff37db" }

    before do
      create(:communication_log, template_id: notify_confirmation_letter_id, message_type: "letter")
      create(:communication_log, template_id: notify_confirmation_letter_id, message_type: "email")
      create(:communication_log, template_id: registration_edit_link_email_id, template_label: "Registration edit link email")
      create(:communication_log, template_id: registration_edit_link_email_id, template_label: "Update your contact details and deregister your waste exemptions")
    end

    # By default Rails prevents multiple invocations of the same Rake task in succession
    after { rake_task.reenable }

    it { expect { run_rake_task }.not_to raise_error }

    it {
      expect { run_rake_task }.to change {
                                    WasteExemptionsEngine::CommunicationLog.where(
                                      template_id: notify_confirmation_letter_id,
                                      message_type: "email"
                                    ).count
                                  }.to 0
    }

    it {
      expect { run_rake_task }.to change {
                                    WasteExemptionsEngine::CommunicationLog.where(
                                      template_id: notify_confirmation_letter_id,
                                      message_type: "letter"
                                    ).count
                                  }.to 2
    }

    it {
      expect { run_rake_task }.to change {
                                    WasteExemptionsEngine::CommunicationLog.where(
                                      template_id: registration_edit_link_email_id,
                                      template_label: "Update your contact details and deregister your waste exemptions"
                                    ).count
                                  }.to 0
    }

    it {
      expect { run_rake_task }.to change {
                                    WasteExemptionsEngine::CommunicationLog.where(
                                      template_id: registration_edit_link_email_id,
                                      template_label: "Registration edit link email"
                                    ).count
                                  }.to 2
    }
  end

  describe "#fix_communication_log_first_renewal_template_label" do
    let(:rake_task) { Rake::Task["one_off:fix_communication_log_first_renewal_template_label"] }
    let(:notify_first_renewal_reminder_email_id) { "1ef273a9-b5e5-4a48-a343-cf6c774b8211" }

    before do
      create(:communication_log, template_id: notify_first_renewal_reminder_email_id, message_type: "email", template_label: "Final renewal reminder email")
    end

    after { rake_task.reenable }

    it { expect { run_rake_task }.not_to raise_error }

    it {
      expect { run_rake_task }.to change {
                                    WasteExemptionsEngine::CommunicationLog.where(
                                      template_id: notify_first_renewal_reminder_email_id,
                                      template_label: "Final renewal reminder email"
                                    ).count
                                  }.to 0
    }

    it {
      expect { run_rake_task }.to change {
                                    WasteExemptionsEngine::CommunicationLog.where(
                                      template_id: notify_first_renewal_reminder_email_id,
                                      template_label: "First renewal reminder email"
                                    ).count
                                  }.to 1
    }
  end
end
