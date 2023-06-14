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

    context "when the resource is not a registration or a new_registration" do
      let(:resource) { nil }

      it "returns the correct path" do
        expect(helper.view_link_for(resource)).to eq("#")
      end
    end
  end

  describe "resume_link_for" do
    context "when the resource is a new_registration" do
      let(:resource) { create(:new_registration) }

      it "returns the correct path" do
        path = WasteExemptionsEngine::Engine.routes.url_helpers.new_start_form_path(resource.token)
        expect(helper.resume_link_for(resource)).to eq(path)
      end

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
        path = WasteExemptionsEngine::Engine.routes.url_helpers.new_edit_form_path(resource.reference)
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
    context "when the resource is a new_registration" do
      let(:resource) { create(:new_registration) }

      context "when the user has permission" do
        before { allow(helper).to receive(:can?).and_return(true) }

        it "returns true" do
          expect(helper.display_resume_link_for?(resource)).to be(true)
        end
      end

      context "when the user does not have permission" do
        before { allow(helper).to receive(:can?).and_return(false) }

        it "returns false" do
          expect(helper.display_resume_link_for?(resource)).to be(false)
        end
      end
    end

    context "when the resource is not a new_registration" do
      let(:resource) { nil }

      it "returns false" do
        expect(helper.display_resume_link_for?(resource)).to be(false)
      end
    end
  end

  describe "display_edit_link_for?" do
    context "when the resource is a registration" do
      let(:resource) { create(:registration) }

      before { allow(helper).to receive(:can?).with(:update, resource).and_return(can) }

      context "when the user has permission to update a registration" do
        let(:can) { true }

        it "returns true" do
          expect(helper.display_edit_link_for?(resource)).to be(true)
        end
      end

      context "when the user does not have permission to update a registration" do
        let(:can) { false }

        it "returns false" do
          expect(helper.display_edit_link_for?(resource)).to be(false)
        end
      end
    end

    context "when the resource is not a registration" do
      let(:resource) { nil }

      it "returns false" do
        expect(helper.display_edit_link_for?(resource)).to be(false)
      end
    end
  end

  describe "display_edit_expiry_date_link_for?" do
    context "when the resource is a registration" do
      let(:resource) { create(:registration) }

      before { allow(helper).to receive(:can?).with(:update_expiry_date, resource).and_return(can) }

      context "when the user has permission to update a registration" do
        let(:can) { true }

        it "returns true" do
          expect(helper.display_edit_expiry_date_link_for?(resource)).to be(true)
        end
      end

      context "when the user does not have permission to update a registration" do
        let(:can) { false }

        it "returns false" do
          expect(helper.display_edit_expiry_date_link_for?(resource)).to be(false)
        end
      end
    end

    context "when the resource is not a registration" do
      let(:resource) { nil }

      it "returns false" do
        expect(helper.display_edit_expiry_date_link_for?(resource)).to be(false)
      end
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

        it "returns true" do
          expect(helper.display_deregister_link_for?(resource)).to be(true)
        end
      end

      context "when the user does not have permission to deregister a registration" do
        let(:can) { false }

        it "returns false" do
          expect(helper.display_deregister_link_for?(resource)).to be(false)
        end
      end
    end

    context "when the resource is an inactive registration" do
      let(:resource) do
        registration = create(:registration)
        registration.registration_exemptions.each(&:revoke!)
        registration
      end

      it "returns false" do
        expect(helper.display_deregister_link_for?(resource)).to be(false)
      end
    end

    context "when the resource is not a registration" do
      let(:resource) { nil }

      it "returns false" do
        expect(helper.display_deregister_link_for?(resource)).to be(false)
      end
    end
  end

  describe "display_resend_deregistration_email_link_for?" do
    let(:can) { true }

    before { allow(helper).to receive(:can?).with(:resend_registration_email, resource).and_return(can) }

    context "when the resource is an active registration" do
      let(:resource) { create(:registration, :with_active_exemptions) }

      context "when the user has permission to deregister a registration" do
        let(:can) { true }

        it "returns true" do
          expect(helper.display_resend_deregistration_email_link_for?(resource)).to be(true)
        end
      end

      context "when the user does not have permission to deregister a registration" do
        let(:can) { false }

        it "returns false" do
          expect(helper.display_resend_deregistration_email_link_for?(resource)).to be(false)
        end
      end

      context "when the resource is not inside the renewal window" do
        let(:can) { true }

        before do
          allow(resource).to receive(:in_renewal_window?).and_return(true)
        end

        it "returns false" do
          expect(helper.display_resend_deregistration_email_link_for?(resource)).to be(false)
        end
      end
    end

    context "when the resource is an already renewed registration" do
      let(:resource) { create(:registration, :with_active_exemptions) }

      before { resource.referred_registration = create(:registration) }

      it "returns false" do
        expect(helper.display_resend_deregistration_email_link_for?(resource)).to be(false)
      end
    end

    context "when the resource is a ceased registration" do
      let(:resource) { create(:registration, :with_ceased_exemptions) }

      it "returns false" do
        expect(helper.display_resend_deregistration_email_link_for?(resource)).to be(false)
      end
    end

    context "when the resource is an expired registration" do
      let(:resource) { create(:registration, registration_exemptions: build_list(:registration_exemption, 3, :expired)) }

      it "returns false" do
        expect(helper.display_resend_deregistration_email_link_for?(resource)).to be(false)
      end
    end

    context "when the resource is not a registration" do
      let(:resource) { nil }

      it "returns false" do
        expect(helper.display_resend_deregistration_email_link_for?(resource)).to be(false)
      end
    end
  end

  describe "display_confirmation_letter_link_for?" do
    context "when the resource is a registration" do
      let(:resource) { create(:registration) }

      context "when the registration is active" do
        it "returns true" do
          expect(helper.display_confirmation_letter_link_for?(resource)).to be(true)
        end
      end

      context "when the resource is an inactive registration" do
        let(:resource) do
          registration = create(:registration)
          registration.registration_exemptions.each(&:revoke!)
          registration
        end

        it "returns false" do
          expect(helper.display_confirmation_letter_link_for?(resource)).to be(false)
        end
      end
    end

    context "when the resource is not a registration" do
      let(:resource) { nil }

      it "returns false" do
        expect(helper.display_confirmation_letter_link_for?(resource)).to be(false)
      end
    end
  end

  describe "display_renew_links_for?" do
    context "when the resource is a registration" do
      let(:resource) { create(:registration) }

      context "when the resource is in the renewal window" do
        before { allow(resource).to receive(:in_renewal_window?).and_return(true) }

        context "when the user has permission to renew" do
          before { allow(helper).to receive(:can?).with(:renew, resource).and_return(can) }

          context "when the resource has active exemptions" do
            before do
              resource.registration_exemptions.each do |re|
                re.state = "active"
                re.save!
              end
            end

            let(:can) { true }

            it "returns true" do
              expect(helper.display_renew_links_for?(resource)).to be(true)
            end
          end

          context "when the resource has expired exemptions" do
            before do
              resource.registration_exemptions.each do |re|
                re.state = "expired"
                re.save!
              end
            end

            let(:can) { true }

            it "returns true" do
              expect(helper.display_renew_links_for?(resource)).to be(true)
            end
          end

          context "when the resource has no active or expired exemptions" do
            before do
              resource.registration_exemptions.each do |re|
                re.state = "ceased"
                re.save!
              end
            end

            let(:can) { true }

            it "returns false" do
              expect(helper.display_renew_links_for?(resource)).to be(false)
            end
          end
        end

        context "when the user does not have permission to renew" do
          let(:can) { false }

          it "returns false" do
            expect(helper.display_renew_links_for?(resource)).to be(false)
          end
        end
      end

      context "when the resource is not in the renewal window" do
        before { allow(resource).to receive(:in_renewal_window?).and_return(false) }

        it "returns false" do
          expect(helper.display_renew_links_for?(resource)).to be(false)
        end
      end
    end

    context "when the resource is not a registration" do
      let(:resource) { nil }

      it "returns false" do
        expect(helper.display_renew_links_for?(resource)).to be(false)
      end
    end
  end

  describe "display_renew_window_closed_text_for?" do
    context "when the resource is a registration" do
      let(:resource) { create(:registration) }

      context "when the resource is past the renewal window" do
        before { allow(resource).to receive(:past_renewal_window?).and_return(true) }

        context "when the user has permission to renew" do
          before { allow(helper).to receive(:can?).with(:renew, resource).and_return(can) }

          context "when the resource has active exemptions" do
            before do
              resource.registration_exemptions.each do |re|
                re.state = "active"
                re.save!
              end
            end

            let(:can) { true }

            it "returns true" do
              expect(helper.display_renew_window_closed_text_for?(resource)).to be(true)
            end
          end

          context "when the resource has expired exemptions" do
            before do
              resource.registration_exemptions.each do |re|
                re.state = "expired"
                re.save!
              end
            end

            let(:can) { true }

            it "returns true" do
              expect(helper.display_renew_window_closed_text_for?(resource)).to be(true)
            end
          end

          context "when the resource has no active or expired exemptions" do
            before do
              resource.registration_exemptions.each do |re|
                re.state = "ceased"
                re.save!
              end
            end

            let(:can) { true }

            it "returns false" do
              expect(helper.display_renew_window_closed_text_for?(resource)).to be(false)
            end
          end
        end

        context "when the user does not have permission to renew" do
          let(:can) { false }

          it "returns false" do
            expect(helper.display_renew_window_closed_text_for?(resource)).to be(false)
          end
        end
      end

      context "when the resource is not in the renewal window" do
        before { allow(resource).to receive(:in_renewal_window?).and_return(false) }

        it "returns false" do
          expect(helper.display_renew_window_closed_text_for?(resource)).to be(false)
        end
      end
    end

    context "when the resource is not a registration" do
      let(:resource) { nil }

      it "returns false" do
        expect(helper.display_renew_window_closed_text_for?(resource)).to be(false)
      end
    end
  end

  describe "display_already_renewed_text_for?" do
    context "when the resource is a registration" do
      let(:resource) { create(:registration) }

      before { allow(helper).to receive(:can?).with(:renew, resource).and_return(can) }

      context "when the user has permission to renew" do
        let(:can) { true }

        before do
          allow(resource).to receive(:in_renewal_window?).and_return(in_renewal_window)
        end

        context "when the resource is in the renewal window" do
          let(:in_renewal_window) { true }

          before do
            allow(resource).to receive(:already_renewed?).and_return(already_renewed)
          end

          context "when the resource is already renewed" do
            let(:already_renewed) { true }

            it "returns true" do
              expect(helper.display_already_renewed_text_for?(resource)).to be(true)
            end
          end

          context "when the resource is not already renewed" do
            let(:already_renewed) { false }

            it "returns false" do
              expect(helper.display_already_renewed_text_for?(resource)).to be(false)
            end
          end
        end

        context "when the resource is not in the renewal window" do
          let(:in_renewal_window) { false }

          it "returns false" do
            expect(helper.display_already_renewed_text_for?(resource)).to be(false)
          end
        end
      end

      context "when the user has no permission to renew" do
        let(:can) { false }

        it "returns false" do
          expect(helper.display_already_renewed_text_for?(resource)).to be(false)
        end
      end
    end

    context "when the resource is not a registration" do
      let(:resource) { nil }

      it "returns false" do
        expect(helper.display_renew_window_closed_text_for?(resource)).to be(false)
      end
    end
  end

  describe "#display_refresh_registered_company_name_link?" do
    context "when the resource is a registration" do
      let(:resource) { create(:registration) }

      before do
        allow(helper).to receive(:can?).with(:update, resource).and_return(can)
      end

      context "when the user has permission to update a registration" do
        let(:can) { true }

        context "when the resource is a limited company or limited liability partnership" do
          before do
            allow(resource).to receive(:company_no_required?).and_return(true)
          end

          it "returns true" do
            expect(helper.display_refresh_registered_company_name_link_for?(resource)).to be(true)
          end
        end

        context "when the resource is neither a limited company nor a limited liability partnership" do
          before do
            allow(resource).to receive(:company_no_required?).and_return(false)
          end

          it "returns false" do
            expect(helper.display_refresh_registered_company_name_link_for?(resource)).to be(false)
          end
        end
      end

      context "when the user doesn't have permission to update a registration" do
        let(:can) { false }

        it "returns false" do
          expect(helper.display_refresh_registered_company_name_link_for?(resource)).to be(false)
        end
      end
    end

    context "when the resourse is not a registration" do
      let(:resource) { nil }

      it "returns false" do
        expect(helper.display_refresh_registered_company_name_link_for?(resource)).to be(false)
      end
    end
  end
end
