# frozen_string_literal: true

require "rails_helper"

RSpec.describe User do
  describe "PaperTrail", :versioning do
    let(:user) { create(:user, :data_viewer) }

    it "has PaperTrail" do
      expect(PaperTrail).to be_enabled
    end

    it "is versioned" do
      expect(user).to be_versioned
    end

    it "creates a new version when it is updated" do
      expect { user.update(role: "customer_service_adviser") }.to change { user.versions.count }.by(1)
    end

    it "stores the correct values when it is updated" do
      user.update(role: "customer_service_adviser")
      user.update(role: "data_viewer")
      expect(user).to have_a_version_with(role: "data_viewer")
    end
  end

  describe "#role" do
    context "when the role is in the allowed list" do
      let(:user) { build(:user, role: "system") }

      it "is valid" do
        expect(user).to be_valid
      end
    end

    context "when the role is not in the allowed list" do
      let(:user) { build(:user, role: "foo") }

      it "is not valid" do
        expect(user).not_to be_valid
      end
    end
  end

  describe "#password" do
    context "when the user's password meets the requirements" do
      let(:user) { build(:user, password: "Secret123") }

      it "is valid" do
        expect(user).to be_valid
      end
    end

    context "when the user's password is blank" do
      let(:user) { build(:user, password: "") }

      it "is not valid" do
        expect(user).not_to be_valid
      end
    end

    context "when the user's password has no lowercase letters" do
      let(:user) { build(:user, password: "SECRET123") }

      it "is not valid" do
        expect(user).not_to be_valid
      end
    end

    context "when the user's password has no uppercase letters" do
      let(:user) { build(:user, password: "secret123") }

      it "is not valid" do
        expect(user).not_to be_valid
      end
    end

    context "when the user's password has no numbers" do
      let(:user) { build(:user, password: "SuperSecret") }

      it "is not valid" do
        expect(user).not_to be_valid
      end
    end

    context "when the user's password is too short" do
      let(:user) { build(:user, password: "Sec123") }

      it "is not valid" do
        expect(user).not_to be_valid
      end
    end
  end

  describe "active?" do
    let(:user) { build(:user) }

    context "when active is true" do
      it "returns true" do
        expect(user.active?).to be(true)
      end
    end

    context "when active is false" do
      before { user.active = false }

      it "returns false" do
        expect(user.active?).to be(false)
      end
    end
  end

  describe "activate" do
    let(:user) { build(:user, :inactive) }

    it "makes the user active" do
      user.activate!
      expect(user.active?).to be(true)
    end
  end

  describe "deactivate" do
    let(:user) { build(:user) }

    it "makes the user inactive" do
      user.deactivate!
      expect(user.active?).to be(false)
    end
  end

  describe "role_is?" do
    let(:user) { build(:user, role: "system") }

    context "when the user has the same role" do
      it "returns true" do
        role = user.role
        expect(user.role_is?(role)).to be(true)
      end
    end

    context "when the user has a different role" do
      it "returns false" do
        role = "data_viewer"
        expect(user.role_is?(role)).to be(false)
      end
    end
  end

  describe "change_role" do
    let(:user) { create(:user, :data_viewer) }

    it "updates the user's role" do
      new_role = "customer_service_adviser"
      user.change_role(new_role)

      expect(user.reload.role).to eq(new_role)
    end

    context "when the new role is invalid" do
      it "does not update the user's role" do
        new_role = "foo"
        user.change_role(new_role)

        expect(user.reload.role).not_to eq(new_role)
      end
    end
  end
end
