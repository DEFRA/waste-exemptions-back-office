# frozen_string_literal: true

namespace :one_off do
  # https://eaflood.atlassian.net/browse/RUBY-4501
  # rake one_off:send_reform_comms_letters[500,live-run] to send a batch of up to 500 letters,
  # otherwise runs in dry-run mode by default. Leave the batch size blank to use the default (1,000).
  desc "Send a batch of reform comms letters to each unique contact on an active registration with no contact email"
  task :send_reform_comms_letters, %i[batch_size mode] => [:environment] do |_task, args|
    dry_run = args[:mode] != "live-run"
    batch_size = (args[:batch_size].presence || SendReformCommsLettersService::DEFAULT_BATCH_SIZE).to_i

    puts "[DRY RUN] No letters will be sent" if dry_run

    result = SendReformCommsLettersService.run(batch_size:, dry_run:)

    if dry_run
      result[:letters].each do |letter|
        puts "#{letter[:recipient]} (#{letter[:references].size}): #{letter[:references].join(', ')}"
      end
    end

    puts "Letters #{dry_run ? 'to send' : 'sent'}: #{result[:letters_sent]}",
         "Registrations covered: #{result[:registrations_covered]}"

    { failed: :error, unsendable: :reason }.each do |outcome, detail|
      next if result[outcome].empty?

      puts "#{outcome.to_s.capitalize}: #{result[outcome].size}"
      result[outcome].each { |item| puts "  #{item[:references].join(', ')}: #{item[detail]}" }
    end

    puts "Stopped early: Notify limit exceeded." if result[:rate_limited]
    puts "Letters remaining: #{result[:letters_remaining]}"
  end
end
