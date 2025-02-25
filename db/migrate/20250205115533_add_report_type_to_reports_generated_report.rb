# frozen_string_literal: true

class AddReportTypeToReportsGeneratedReport < ActiveRecord::Migration[7.1]
  def change
    add_column :reports_generated_reports, :report_type, :string, null: false, default: "bulk"
  end
end
