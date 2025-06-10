# frozen_string_literal: true

namespace :test do
  # bundle exec rake test:govpay_signature['{"refund_id":"123"\,"created_date":"2022-01-26T16:52:41.178Z"\,
  # "amount":2000\,"status":"success"\,"settlement_summary":{}\,"payment_id":"789"}']
  # Note: The body argument should not contan any un-escaped commas
  desc "Generate GovPay signature for a given request body"
  task :govpay_signature, [:body] => :environment do |_t, args|
    abort "The Rails environment is running in production mode!" if Rails.env.production?

    abort "missing body argument" if args[:body].nil?

    body = args[:body]
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
