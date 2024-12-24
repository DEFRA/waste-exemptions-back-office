# frozen_string_literal: true

class CompaniesHouseNameMatchingReportService
  attr_reader :report_path, :summary_path

  def initialize(report_path = nil)
    @report_path = set_report_path(report_path) || default_report_path
    @summary_path = @report_path.sub('.csv', '_summary.csv')
    @started_at = Time.current
    @processed_count = 0
    @updated_count = 0
    @skipped_count = 0
    ensure_report_directory
    initialize_csv unless File.exist?(@report_path)
    log_report_path
  end

  def record_processed
    @processed_count += 1
  end

  def record_updated
    @updated_count += 1
  end

  def record_skipped
    @skipped_count += 1
  end

  def record_change(registration, companies_house_name, similarity = nil)
    CSV.open(report_path, 'a') do |csv|
      csv << [
        registration.reference,
        registration.company_no,
        registration.operator_name,
        companies_house_name,
        similarity&.round(2),
        'CHANGE'
      ]
    end
  end

  def record_skip(registration, reason)
    CSV.open(report_path, 'a') do |csv|
      csv << [
        registration.reference,
        registration.company_no,
        registration.operator_name,
        nil,
        nil,
        "SKIP: #{reason}"
      ]
    end
  end

  def record_error(company_no, error)
    CSV.open(report_path, 'a') do |csv|
      csv << [
        nil,
        company_no,
        nil,
        nil,
        nil,
        "ERROR: #{error.message}"
      ]
    end
  end

  def finalize
    create_summary_report
  end

  private

  def default_report_path
    date = Time.current.strftime('%Y%m%d')
    Rails.root.join('public', 'company_reports', "companies_house_update_#{date}.csv")
  end

  def ensure_report_directory
    FileUtils.mkdir_p(File.dirname(report_path))
  end

  def initialize_csv
    puts "Creating new report at: #{@report_path}"
    CSV.open(report_path, 'w') do |csv|
      csv << ['Companies House Name Matching Report']
      csv << ['Started at', @started_at]
      csv << []
      csv << ['Registration Ref', 'Company Number', 'Current Name', 'Companies House Name', 'Similarity Score', 'Status']
    end
  end

  def create_summary_report
    CSV.open(summary_path, 'w') do |csv|
      csv << ['Companies House Name Matching Summary']
      csv << ['Started at', @started_at]
      csv << ['Completed at', Time.current]
      csv << []
      csv << ['Summary Statistics']
      csv << ['Total Companies Processed', @processed_count]
      csv << ['Companies Updated', @updated_count]
      csv << ['Companies Skipped', @skipped_count]
      csv << []
      csv << ['Report Location:', File.basename(report_path)]
    end
  end

  def set_report_path(report_path)
    Rails.root.join('public', 'company_reports', report_path)
  end


  def log_report_path
    relative_path = report_path.to_s.sub(Rails.root.join('public').to_s, '')
    puts "Report will be generated at: #{relative_path}"
  end
end
