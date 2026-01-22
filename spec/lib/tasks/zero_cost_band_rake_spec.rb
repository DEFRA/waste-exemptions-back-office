# frozen_string_literal: true

require "rails_helper"
require "rake"

RSpec.describe "bands:zero_cost_band", type: :rake do
  let(:service_instance) { instance_double(ZeroCostBandService) }

  before do
    allow(ZeroCostBandService).to receive(:new).and_return(service_instance)
  end

  describe "bands:create_zero_cost_band" do
    before do
      allow(ZeroCostBandService).to receive(:run)
      Rake::Task["bands:create_zero_cost_band"].reenable
    end

    it "calls the service" do
      Rake::Task["bands:create_zero_cost_band"].invoke

      expect(ZeroCostBandService).to have_received(:run)
    end
  end

  describe "bands:assign_t28_to_zero_cost_band" do
    before do
      allow(service_instance).to receive(:assign_exemption).and_return(true)
      Rake::Task["bands:assign_t28_to_zero_cost_band"].reenable
    end

    it "calls the service with T28" do
      Rake::Task["bands:assign_t28_to_zero_cost_band"].invoke

      expect(service_instance).to have_received(:assign_exemption).with("T28")
    end

    context "when the service returns false" do
      before do
        allow(service_instance).to receive(:assign_exemption).and_return(false)
      end

      it "exits with error" do
        expect { Rake::Task["bands:assign_t28_to_zero_cost_band"].invoke }
          .to raise_error(SystemExit)
      end
    end
  end

  describe "bands:setup_zero_cost_band" do
    before do
      allow(ZeroCostBandService).to receive(:run)
      allow(service_instance).to receive(:assign_exemption).and_return(true)
      Rake::Task["bands:setup_zero_cost_band"].reenable
      Rake::Task["bands:create_zero_cost_band"].reenable
      Rake::Task["bands:assign_t28_to_zero_cost_band"].reenable
    end

    it "invokes both tasks" do
      Rake::Task["bands:setup_zero_cost_band"].invoke

      expect(ZeroCostBandService).to have_received(:run)
      expect(service_instance).to have_received(:assign_exemption).with("T28")
    end
  end
end
