# frozen_string_literal: true

namespace :reports do
  namespace :export do
    desc "Generate the finance data reports and upload them to S3."
    task finance_data: :environment do
      Reports::GeneratedReport.finance_data.delete_all
      Reports::FinanceDataReport::ExportService.run
    end

    desc "Generate the EPR report and upload it to S3."
    task epr: :environment do
      Reports::EprExportService.run
    end

    desc "Generate the monthly bulk data reports and upload them to S3."
    task bulk: :environment do
      Reports::BulkExportService.run
    end

    desc "Generate the BOXI report (zipped) and upload it to S3."
    task boxi: :environment do
      Reports::BoxiExportService.run
    end
  end
end
