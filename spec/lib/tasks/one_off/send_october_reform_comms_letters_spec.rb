# frozen_string_literal: true

require "rails_helper"

# rubocop:disable-next RSpec/ExpectOutput
RSpec.describe "one_off:send_october_reform_comms_letters", type: :rake do
  original_stdout = $stdout # rubocop:disable RSpec/LeakyLocalVariable

  subject(:run_rake_task) { rake_task.invoke("500", "live-run") }

  include_context "rake"

  let(:rake_task) { Rake::Task["one_off:send_october_reform_comms_letters"] }
  let(:default_batch_size) { SendOctoberReformCommsLettersService::DEFAULT_BATCH_SIZE }

  let(:result) do
    {
      letters_sent: 2,
      registrations_covered: 3,
      letters: [
        { references: %w[WEX1 WEX2], recipient: "Jane Smith, 1 High Street, Bristol, BS1 1AA" },
        { references: %w[WEX3], recipient: "Tom Jones, 2 Low Road, Bath, BA1 1AA" }
      ],
      failed: [],
      unsendable: [],
      letters_remaining: 5,
      rate_limited: false
    }
  end

  before do
    $stdout = StringIO.new
    allow(SendOctoberReformCommsLettersService).to receive(:run).and_return(result)
  end

  after do
    $stdout = original_stdout
    rake_task.reenable
  end

  it { expect { run_rake_task }.not_to raise_error }

  it "sends a batch of letters" do
    run_rake_task

    expect(SendOctoberReformCommsLettersService).to have_received(:run).with(batch_size: 500, dry_run: false)
  end

  it "outputs the letters sent, the registrations they cover and the letters remaining" do
    expect { run_rake_task }.to output(
      "Letters sent: 2\nRegistrations covered: 3\nLetters remaining: 5\n"
    ).to_stdout
  end

  context "when no batch size is given" do
    it "sends the default batch size of letters" do
      rake_task.invoke("", "live-run")

      expect(SendOctoberReformCommsLettersService).to have_received(:run).with(batch_size: default_batch_size, dry_run: false)
    end
  end

  context "when some letters fail or are unsendable" do
    let(:result) do
      super().merge(failed: [{ references: %w[WEX4], error: "Connection reset" }],
                    unsendable: [{ references: %w[WEX5 WEX6], reason: "no contact address postcode" },
                                 { references: %w[WEX7], reason: "too few contact address lines" }])
    end

    it "outputs them with their references and the reasons" do
      expect { run_rake_task }.to output(
        a_string_including("Failed: 1\n  WEX4: Connection reset\n",
                           "Unsendable: 2\n  WEX5, WEX6: no contact address postcode\n  " \
                           "WEX7: too few contact address lines\n")
      ).to_stdout
    end
  end

  context "when Notify stops the batch for exceeding a limit" do
    let(:result) { super().merge(rate_limited: true) }

    it "outputs that the batch stopped early" do
      expect { run_rake_task }.to output(/Stopped early: Notify limit exceeded/).to_stdout
    end
  end

  context "when running in dry run mode (default)" do
    subject(:run_rake_task) { rake_task.invoke }

    it "does not send the letters" do
      run_rake_task

      expect(SendOctoberReformCommsLettersService).to have_received(:run).with(batch_size: default_batch_size, dry_run: true)
    end

    it "outputs each letter it would send and the totals" do
      expect { run_rake_task }.to output(
        "[DRY RUN] No letters will be sent\n" \
        "Jane Smith, 1 High Street, Bristol, BS1 1AA (2): WEX1, WEX2\n" \
        "Tom Jones, 2 Low Road, Bath, BA1 1AA (1): WEX3\n" \
        "Letters to send: 2\nRegistrations covered: 3\nLetters remaining: 5\n"
      ).to_stdout
    end
  end
end
