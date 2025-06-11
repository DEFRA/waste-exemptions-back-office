# frozen_string_literal: true

namespace :one_off do
  # bundle exec rake one_off:govpay_signature['{"refund_id":"123"\,"created_date":"2022-01-26T16:52:41.178Z"\,
  # "amount":2000\,"status":"success"\,"settlement_summary":{}\,"payment_id":"789"}']
  # Note: The body argument should not contan any un-escaped commas
  desc "Generate GovPay signature for a given request body"
  task :govpay_signature, %i[body] => [:environment] do |_t, args|
    body = args[:body]
    abort "missing body argument" if body.blank?

    signature = DefraRubyGovpay::WebhookSignatureService.run(body: body)

    puts "=" * 80
    puts "Body:"
    pp body
    puts "-" * 80
    puts "Signature:"
    pp signature
    puts "=" * 80
  end
end
