# frozen_string_literal: true

require "rails_helper"

RSpec.describe "one_off:send_october_reform_comms_letters", type: :rake do
  include_context "rake"

  it_behaves_like "a reform comms letters rake task" do
    let(:rake_task) { Rake::Task["one_off:send_october_reform_comms_letters"] }
    let(:sender) { SendOctoberReformCommsLettersService }
  end
end
