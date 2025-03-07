# frozen_string_literal: true

require "rails_helper"

RSpec.describe ActionLinksHelper do
  include Devise::Test::ControllerHelpers

  describe "view_link_for" do
    context "when the resource is a registration" do
      let(:resource) { create(:registration) }

      it "returns the correct path" do
        expect(helper.view_link_for(resource)).to eq(registration_path(resource.reference))
      end
    end

    context "when the resource is a new_registration" do
      let(:resource) { create(:new_registration) }

      it "returns the correct path" do
        expect(helper.view_link_for(resource)).to eq(new_registration_path(resource.id))
      end
    end

    context "when the resource is a new_charged_registration" do
      let(:resource) { create(:new_charged_registration) }

      it "returns the correct path" do
        expect(helper.view_link_for(resource)).to eq(new_registration_path(resource.id))
      end
    end

    context "when the resource is not a registration or a new_registration" do
      let(:resource) { nil }

      it "returns the correct path" do
        expect(helper.view_link_for(resource)).to eq("#")
      end
    end
  end

  describe "resume_link_for" do
    shared_examples "assistance mode changes" do
      context "when the registration was started in the back office" do
        it "does not change the assistance_mode" do
          expect { helper.resume_link_for(resource) }.not_to change(resource, :assistance_mode)
        end
      end

      context "when the registration was started in the front office" do
        before { resource.assistance_mode = nil }

        it "changes the assistance mode to partial" do
          expect { helper.resume_link_for(resource) }.to change(resource, :assistance_mode).to("partial")
        end
      end
    end

    context "when the resource is a new_registration" do
      let(:resource) { create(:new_registration) }

      it "returns the correct path" do
        path = WasteExemptionsEngine::Engine.routes.url_helpers.new_start_form_path(resource.token)
        expect(helper.resume_link_for(resource)).to eq(path)
      end

      it_behaves_like "assistance mode changes"
    end

    context "when the resource is a new_charged_registration" do
      let(:resource) { create(:new_charged_registration) }

      it "returns the correct path" do
        path = WasteExemptionsEngine::Engine.routes.url_helpers.new_start_form_path(resource.token)
        expect(helper.resume_link_for(resource)).to eq(path)
      end

      it_behaves_like "assistance mode changes"
    end

    context "when the resource is not a new_registration" do
      let(:resource) { nil }

      it "returns the correct path" do
        expect(helper.resume_link_for(resource)).to eq("#")
      end
    end
  end

  describe "edit_link_for" do
    context "when the resource is a registration" do
      let(:resource) { create(:registration) }

      it "returns the correct path" do
        path = WasteExemptionsEngine::Engine.routes.url_helpers.new_back_office_edit_form_path(resource.reference)
        expect(helper.edit_link_for(resource)).to eq(path)
      end
    end

    context "when the resource is not a registration" do
      let(:resource) { nil }

      it "returns the correct path" do
        expect(helper.edit_link_for(resource)).to eq("#")
      end
    end
  end

  describe "edit_expiry_date_link_for" do
    context "when the resource is a registration" do
      let(:resource) { create(:registration) }

      it "returns the correct path" do
        path = Rails.application.routes.url_helpers.modify_expiry_date_form_path(resource.reference)
        expect(helper.edit_expiry_date_link_for(resource)).to eq(path)
      end
    end

    context "when the resource is not a registration" do
      let(:resource) { nil }

      it "returns the correct path" do
        expect(helper.edit_expiry_date_link_for(resource)).to eq("#")
      end
    end
  end

  describe "display_resume_link_for?" do
    shared_examples "displays the resume link" do
      context "when the user has permission" do
        before { allow(helper).to receive(:can?).and_return(true) }

        it { expect(helper.display_resume_link_for?(resource)).to be(true) }
      end

      context "when the user does not have permission" do
        before { allow(helper).to receive(:can?).and_return(false) }

        it { expect(helper.display_resume_link_for?(resource)).to be(false) }
      end
    end

    context "when the resource is a new_registration" do
      let(:resource) { create(:new_registration) }

      it_behaves_like "displays the resume link"
    end

    context "when the resource is a new_charged_registration" do
      let(:resource) { create(:new_charged_registration) }

      it_behaves_like "displays the resume link"
    end

    context "when the resource is not a new_registration" do
      let(:resource) { nil }

      it { expect(helper.display_resume_link_for?(resource)).to be(false) }
    end
  end

  describe "display_edit_link_for?" do
    context "when the resource is a registration" do
      let(:resource) { create(:registration) }

      before { allow(helper).to receive(:can?).with(:update, resource).and_return(can) }

      context "when the user has permission to update a registration" do
        let(:can) { true }

        it { expect(helper.display_edit_link_for?(resource)).to be(true) }
      end

      context "when the user does not have permission to update a registration" do
        let(:can) { false }

        it { expect(helper.display_edit_link_for?(resource)).to be(false) }
      end
    end

    context "when the resource is not a registration" do
      let(:resource) { nil }

      it { expect(helper.display_edit_link_for?(resource)).to be(false) }
    end
  end

  describe "display_edit_expiry_date_link_for?" do
    context "when the resource is a registration" do
      let(:resource) { create(:registration) }
      let(:can) { true }

      before { allow(helper).to receive(:can?).with(:update_expiry_date, resource).and_return(can) }

      context "when the user has permission to update a registration" do
        let(:can) { true }

        it { expect(helper.display_edit_expiry_date_link_for?(resource)).to be(true) }
      end

      context "when the user does not have permission to update a registration" do
        let(:can) { false }

        it { expect(helper.display_edit_expiry_date_link_for?(resource)).to be(false) }
      end

      context "when the resource has both ceased and active exemptions" do
        before do
          re = resource.registration_exemptions.first
          re.state = "ceased"
          re.save!
        end

        it { expect(helper.display_edit_expiry_date_link_for?(resource)).to be(true) }
      end

      context "when the resource has ceased exemptions only" do
        before do
          resource.registration_exemptions.each do |re|
            re.state = "ceased"
            re.save!
          end
        end

        it { expect(helper.display_edit_expiry_date_link_for?(resource)).to be(false) }
      end

      context "when the resource has both revoked and active exemptions" do
        before do
          re = resource.registration_exemptions.first
          re.state = "revoked"
          re.save!
        end

        it { expect(helper.display_edit_expiry_date_link_for?(resource)).to be(true) }
      end

      context "when the resource has revoked exemptions only" do
        before do
          resource.registration_exemptions.each do |re|
            re.state = "revoked"
            re.save!
          end
        end

        it { expect(helper.display_edit_expiry_date_link_for?(resource)).to be(false) }
      end
    end

    context "when the resource is not a registration" do
      let(:resource) { nil }

      it { expect(helper.display_edit_expiry_date_link_for?(resource)).to be(false) }
    end
  end

  describe "display_deregister_link_for?" do
    context "when the resource is an active registration" do
      let(:resource) do
        registration = create(:registration)
        registration.registration_exemptions.each do |re|
          re.state = "active"
          re.save!
        end
        registration
      end

      before { allow(helper).to receive(:can?).with(:deregister, resource).and_return(can) }

      context "when the user has permission to deregister a registration" do
        let(:can) { true }

        it { expect(helper.display_deregister_link_for?(resource)).to be(true) }
      end

      context "when the user does not have permission to deregister a registration" do
        let(:can) { false }

        it { expect(helper.display_deregister_link_for?(resource)).to be(false) }
      end
    end

    context "when the resource is an inactive registration" do
      let(:resource) do
        registration = create(:registration)
        registration.registration_exemptions.each(&:revoke!)
        registration
      end

      it { expect(helper.display_deregister_link_for?(resource)).to be(false) }
    end

    context "when the resource is not a registration" do
      let(:resource) { nil }

      it { expect(helper.display_deregister_link_for?(resource)).to be(false) }
    end
  end

  describe "display_send_edit_invite_email_link_for?" do
    let(:can) { true }

    before { allow(helper).to receive(:can?).with(:send_comms, resource).and_return(can) }

    context "when the resource is an active registration" do
      let(:resource) { create(:registration, :with_active_exemptions) }

      context "when the user has permission to deregister a registration" do
        let(:can) { true }

        it { expect(helper.display_send_edit_invite_email_link_for?(resource)).to be(true) }
      end

      context "when the user does not have permission to deregister a registration" do
        let(:can) { false }

        it { expect(helper.display_send_edit_invite_email_link_for?(resource)).to be(false) }
      end
    end

    context "when the resource is a ceased registration" do
      let(:resource) { create(:registration, :with_ceased_exemptions) }

      it { expect(helper.display_send_edit_invite_email_link_for?(resource)).to be(false) }
    end

    context "when the resource is an expired registration" do
      let(:resource) { create(:registration, registration_exemptions: build_list(:registration_exemption, 3, :expired)) }

      it { expect(helper.display_send_edit_invite_email_link_for?(resource)).to be(false) }
    end

    context "when the resource is not a registration" do
      let(:resource) { nil }

      it { expect(helper.display_send_edit_invite_email_link_for?(resource)).to be(false) }
    end
  end

  describe "display_confirmation_communication_links_for?" do
    context "when the resource is an active registration" do
      let(:resource) { create(:registration, :with_active_exemptions) }

      before { allow(helper).to receive(:can?).with(:send_comms, resource).and_return(can) }

      context "when the user has permission to send communications" do
        let(:can) { true }

        it { expect(helper.display_confirmation_communication_links_for?(resource)).to be(true) }
      end

      context "when the user does not have permission to send communications" do
        let(:can) { false }

        it { expect(helper.display_confirmation_communication_links_for?(resource)).to be(false) }
      end
    end

    context "when the resource is a ceased registration" do
      let(:resource) { create(:registration, :with_ceased_exemptions) }

      it { expect(helper.display_confirmation_communication_links_for?(resource)).to be(false) }
    end

    context "when the resource is an expired registration" do
      let(:resource) { create(:registration, registration_exemptions: build_list(:registration_exemption, 3, :expired)) }

      it { expect(helper.display_confirmation_communication_links_for?(resource)).to be(false) }
    end

    context "when the resource is not a registration" do
      let(:resource) { nil }

      it { expect(helper.display_confirmation_communication_links_for?(resource)).to be(false) }
    end
  end

  describe "display_renew_links_for?" do
    context "when the resource is a registration" do
      let(:resource) { create(:registration) }

      context "when the resource is in the renewal window" do
        before { allow(resource).to receive(:in_renewal_window?).and_return(true) }

        context "when the user has permission to renew" do
          let(:can) { true }

          before { allow(helper).to receive(:can?).with(:renew, resource).and_return(can) }

          context "when the resource has active exemptions" do
            before do
              resource.registration_exemptions.each do |re|
                re.state = "active"
                re.save!
              end
            end

            it { expect(helper.display_renew_links_for?(resource)).to be(true) }
          end

          context "when the resource has expired exemptions" do
            before do
              resource.registration_exemptions.each do |re|
                re.state = "expired"
                re.save!
              end
            end

            it { expect(helper.display_renew_links_for?(resource)).to be(true) }
          end

          context "when the resource has both ceased and active exemptions" do
            before do
              re = resource.registration_exemptions.first
              re.state = "ceased"
              re.save!
            end

            it { expect(helper.display_renew_links_for?(resource)).to be(true) }
          end

          context "when the resource has ceased exemptions only" do
            before do
              resource.registration_exemptions.each do |re|
                re.state = "ceased"
                re.save!
              end
            end

            it { expect(helper.display_renew_links_for?(resource)).to be(false) }
          end

          context "when the resource has both revoked and active exemptions" do
            before do
              re = resource.registration_exemptions.first
              re.state = "revoked"
              re.save!
            end

            it { expect(helper.display_renew_links_for?(resource)).to be(true) }
          end

          context "when the resource has revoked exemptions only" do
            before do
              resource.registration_exemptions.each do |re|
                re.state = "revoked"
                re.save!
              end
            end

            it { expect(helper.display_renew_links_for?(resource)).to be(false) }
          end

          context "when the resource is not in the renewal window" do
            before { allow(resource).to receive(:in_renewal_window?).and_return(false) }

            it { expect(helper.display_renew_links_for?(resource)).to be(false) }
          end
        end

        context "when the user does not have permission to renew" do
          let(:can) { false }

          it { expect(helper.display_renew_links_for?(resource)).to be(false) }
        end
      end
    end

    context "when the resource is not a registration" do
      let(:resource) { create(:new_registration) }

      it { expect(helper.display_renew_links_for?(resource)).to be(false) }
    end
  end

  describe "display_renew_window_closed_text_for?" do
    context "when the resource is a registration" do
      let(:resource) { create(:registration) }

      context "when the resource is past the renewal window" do
        before { allow(resource).to receive(:past_renewal_window?).and_return(true) }

        context "when the user has permission to renew" do
          before { allow(helper).to receive(:can?).with(:renew, resource).and_return(true) }

          context "when the resource has active exemptions" do
            before do
              resource.registration_exemptions.each do |re|
                re.state = "active"
                re.save!
              end
            end

            it { expect(helper.display_renew_window_closed_text_for?(resource)).to be(true) }
          end

          context "when the resource has expired exemptions" do
            before do
              resource.registration_exemptions.each do |re|
                re.state = "expired"
                re.save!
              end
            end

            it { expect(helper.display_renew_window_closed_text_for?(resource)).to be(true) }
          end

          context "when the resource has no active or expired exemptions" do
            before do
              resource.registration_exemptions.each do |re|
                re.state = "ceased"
                re.save!
              end
            end

            it { expect(helper.display_renew_window_closed_text_for?(resource)).to be(false) }
          end

          context "when the resource is past the renewal window" do
            before { allow(resource).to receive(:past_renewal_window?).and_return(true) }

            it { expect(helper.display_renew_window_closed_text_for?(resource)).to be(true) }
          end
        end

        context "when the user does not have permission to renew" do
          let(:can) { false }

          it { expect(helper.display_renew_window_closed_text_for?(resource)).to be(false) }
        end
      end
    end

    context "when the resource is not a registration" do
      let(:resource) { nil }

      it { expect(helper.display_renew_window_closed_text_for?(resource)).to be(false) }
    end
  end

  describe "display_already_renewed_text_for?" do
    context "when the resource is a registration" do
      let(:resource) { create(:registration) }

      before { allow(helper).to receive(:can?).with(:renew, resource).and_return(can) }

      context "when the user has permission to renew" do
        let(:can) { true }
        let(:in_renewal_window) { true }

        before { allow(resource).to receive(:in_renewal_window?).and_return(in_renewal_window) }

        context "when the resource is in the renewal window" do
          let(:in_renewal_window) { true }

          before { allow(resource).to receive(:already_renewed?).and_return(already_renewed) }

          context "when the resource is already renewed" do
            let(:already_renewed) { true }

            it { expect(helper.display_already_renewed_text_for?(resource)).to be(true) }
          end

          context "when the resource is not already renewed" do
            let(:already_renewed) { false }

            it { expect(helper.display_already_renewed_text_for?(resource)).to be(false) }
          end
        end

        context "when the resource is not in the renewal window" do
          let(:in_renewal_window) { false }

          it { expect(helper.display_already_renewed_text_for?(resource)).to be(false) }
        end
      end

      context "when the user has no permission to renew" do
        let(:can) { false }

        it { expect(helper.display_already_renewed_text_for?(resource)).to be(false) }
      end
    end

    context "when the resource is not a registration" do
      let(:resource) { create(:new_registration) }

      it { expect(helper.display_already_renewed_text_for?(resource)).to be(false) }
    end
  end

  describe "#display_refresh_registered_company_name_link?" do
    context "when the resource is a registration" do
      let(:resource) { create(:registration) }

      before { allow(helper).to receive(:can?).with(:update, resource).and_return(can) }

      context "when the user has permission to update a registration" do
        let(:can) { true }

        context "when the resource is a limited company or limited liability partnership" do
          before { allow(resource).to receive(:company_no_required?).and_return(true) }

          it { expect(helper.display_refresh_registered_company_name_link_for?(resource)).to be(true) }
        end

        context "when the resource is neither a limited company nor a limited liability partnership" do
          before { allow(resource).to receive(:company_no_required?).and_return(false) }

          it { expect(helper.display_refresh_registered_company_name_link_for?(resource)).to be(false) }
        end

        context "when the resourse is not a registration" do
          let(:resource) { nil }

          it { expect(helper.display_refresh_registered_company_name_link_for?(resource)).to be(false) }
        end
      end

      context "when the user doesn't have permission to update a registration" do
        let(:can) { false }

        it { expect(helper.display_refresh_registered_company_name_link_for?(resource)).to be(false) }
      end
    end
  end

  describe "#can_display_refund_link?" do
    context "with no overpayment" do
      let(:registration) { build(:registration, account: build(:account, balance: 0)) }

      it { expect(helper.can_display_refund_link?(registration)).to be false }
    end

    context "with an overpayment" do
      let(:registration) { build(:registration, account: build(:account, :with_payment)) }

      it { expect(helper.can_display_refund_link?(registration)).to be true }
    end
  end

  describe "#can_display_reversal_link?" do

    context "with an overpayment" do
      let(:registration) { create(:registration, account: build(:account)) }

      before do
        registration.account.payments << build(:payment, :bank_transfer)
      end

      it { expect(helper.can_display_reversal_link?(registration)).to be true }
    end

    context "with no overpayment" do
      let(:registration) { create(:registration, account: build(:account, balance: 0)) }

      it { expect(helper.can_display_reversal_link?(registration)).to be false }
    end

    context "with a payment that is not reversible" do
      let(:registration) { create(:registration, account: build(:account)) }
      let(:bank_transfer) { build(:payment, :bank_transfer) }

      before do
        registration.account.payments << bank_transfer
        registration.account.payments << build(:payment, account: registration.account, associated_payment: bank_transfer)
      end

      it { expect(helper.can_display_reversal_link?(registration)).to be false }
    end
  end

  describe "#display_payment_details_link_for?" do
    before { allow(helper).to receive(:can?).with(:read, resource).and_return(true) }

    context "when the resource is not a registration" do
      let(:resource) { nil }

      it "returns false" do
        expect(helper.display_payment_details_link_for?(resource)).to be(false)
      end
    end

    context "when the resource is a registration" do
      context "when the registration does not have an account" do
        let(:resource) { create(:registration, account: nil) }

        it "returns false" do
          expect(helper.display_payment_details_link_for?(resource)).to be(false)
        end
      end

      context "when the registration has an account" do
        let(:resource) { create(:registration, account: build(:account)) }

        it "returns true" do
          expect(helper.display_payment_details_link_for?(resource)).to be(true)
        end
      end
    end
  end
end
