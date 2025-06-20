# frozen_string_literal: true

require "defra_ruby/aws"

# rubocop:disable Metrics/BlockLength
DefraRuby::Aws.configure do |c|
  bulk_bucket = {
    name: ENV.fetch("AWS_BULK_EXPORT_BUCKET", nil),
    region: ENV.fetch("AWS_REGION", nil),
    credentials: {
      access_key_id: ENV.fetch("AWS_BULK_EXPORT_ACCESS_KEY_ID", nil),
      secret_access_key: ENV.fetch("AWS_BULK_EXPORT_SECRET_ACCESS_KEY", nil)
    },
    encrypt_with_kms: ENV.fetch("AWS_BULK_ENCRYPT_WITH_KMS", nil)
  }

  finance_data_bucket = {
    name: ENV.fetch("AWS_FINANCE_DATA_EXPORT_BUCKET", nil),
    region: ENV.fetch("AWS_REGION", nil),
    credentials: {
      access_key_id: ENV.fetch("AWS_FINANCE_DATA_EXPORT_ACCESS_KEY_ID", nil),
      secret_access_key: ENV.fetch("AWS_FINANCE_DATA_EXPORT_SECRET_ACCESS_KEY", nil)
    },
    encrypt_with_kms: ENV.fetch("AWS_FINANCE_DATA_ENCRYPT_WITH_KMS", nil)
  }

  epr_bucket = {
    name: ENV.fetch("AWS_DAILY_EXPORT_BUCKET", nil),
    region: ENV.fetch("AWS_REGION", nil),
    credentials: {
      access_key_id: ENV.fetch("AWS_DAILY_EXPORT_ACCESS_KEY_ID", nil),
      secret_access_key: ENV.fetch("AWS_DAILY_EXPORT_SECRET_ACCESS_KEY", nil)
    },
    encrypt_with_kms: ENV.fetch("AWS_DAILY_ENCRYPT_WITH_KMS", nil)
  }

  deregistration_email_export_bucket = {
    name: ENV.fetch("AWS_DEREGISTRATION_EMAIL_EXPORT_BUCKET", nil),
    region: ENV.fetch("AWS_REGION", nil),
    credentials: {
      access_key_id: ENV.fetch("AWS_DEREGISTRATION_EMAIL_EXPORT_ACCESS_KEY_ID", nil),
      secret_access_key: ENV.fetch("AWS_DEREGISTRATION_EMAIL_EXPORT_SECRET_ACCESS_KEY", nil)
    },
    encrypt_with_kms: ENV.fetch("AWS_DEREGISTRATION_EMAIL_ENCRYPT_WITH_KMS", nil)
  }

  boxi_export_bucket = {
    name: ENV.fetch("AWS_BOXI_EXPORT_BUCKET", nil),
    region: ENV.fetch("AWS_REGION", nil),
    credentials: {
      access_key_id: ENV.fetch("AWS_BOXI_EXPORT_ACCESS_KEY_ID", nil),
      secret_access_key: ENV.fetch("AWS_BOXI_EXPORT_SECRET_ACCESS_KEY", nil)
    },
    encrypt_with_kms: ENV.fetch("AWS_BOXI_ENCRYPT_WITH_KMS", nil)
  }

  govpay_mocks_bucket = {
    name: ENV.fetch("AWS_DEFRA_RUBY_MOCKS_BUCKET", "dummy"),
    region: ENV.fetch("AWS_REGION", "eu-west-1"),
    credentials: {
      access_key_id: ENV.fetch("AWS_DEFRA_RUBY_MOCKS_ACCESS_KEY_ID", nil),
      secret_access_key: ENV.fetch("AWS_DEFRA_RUBY_MOCKS_SECRET_ACCESS_KEY", nil)
    },
    encrypt_with_kms: ENV.fetch("AWS_DEFRA_RUBY_MOCKS_ENCRYPT_WITH_KMS", false)
  }

  c.buckets = [
    bulk_bucket,
    finance_data_bucket,
    epr_bucket,
    boxi_export_bucket,
    deregistration_email_export_bucket,
    govpay_mocks_bucket
  ]
end
# rubocop:enable Metrics/BlockLength
