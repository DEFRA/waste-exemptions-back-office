# frozen_string_literal: true

module CompaniesHouseNameMatching
  module Logging
    private

    def log_batch_info(active_registrations)
      Rails.logger.info do
        <<~INFO
          Total number of registrations in state active overall: #{total_active_registrations}
          Number of active registrations to process in this batch (not recently updated): #{active_registrations.size}
          Total number of recently updated companies: #{WasteExemptionsEngine::Company.recently_updated.count}
        INFO
      end
    end

    def log_unproposed_changes_count
      Rails.logger.info do
        "Total registrations with names too different from Companies House: #{@unproposed_changes.size}"
      end
    end

    def log_summary(proposed_changes, applied: false)
      action = applied ? "applied" : "proposed"
      log_summary_header(action, proposed_changes)
      log_summary_changes(proposed_changes, action)
    end

    def log_unproposed_changes
      Rails.logger.info "\nChanges not proposed (too different from Companies House records):"
      if @unproposed_changes.empty?
        Rails.logger.info " No unproposed changes."
      else
        log_unproposed_changes_details
      end
    end

    def log_summary_header(action, proposed_changes)
      Rails.logger.info("=== Summary ===")
      Rails.logger.info("Total number of company numbers processed this batch: #{@request_count}")
      Rails.logger.info("Total number of company numbers with #{action} name changes: #{proposed_changes.size}")
      Rails.logger.info("Full report available at: /company_reports/#{File.basename(@report.report_path)}")
    end

    def log_summary_changes(proposed_changes, action)
      if proposed_changes.empty?
        Rails.logger.info(" No changes #{action}.")
      else
        log_proposed_changes(proposed_changes)
      end
    end

    def log_proposed_changes(proposed_changes)
      proposed_changes.each do |company_no, changes|
        Rails.logger.info(" Company number: #{company_no}")
        changes.each do |reference, old_name, new_name|
          Rails.logger.info("   Registration reference: #{reference}, Old name: '#{old_name}', New name: '#{new_name}'")
        end
      end
    end

    def log_unproposed_changes_details
      @unproposed_changes.each do |company_no, details|
        Rails.logger.info { " Company number: #{company_no}" }
        details.each do |detail|
          Rails.logger.info { "   Registration reference: #{detail[:registration_reference]}" }
          Rails.logger.info { "   Current name: '#{detail[:current_name]}'" }
          Rails.logger.info { "   Companies House name: '#{detail[:companies_house_name]}'" }
          Rails.logger.info { "   Name similarity: #{detail[:similarity].round(2)}" }
          Rails.logger.info ""
        end
      end
    end

    def log_completion
      Rails.logger.info("Batch complete.")
      Rails.logger.info("Report can be accessed at: /company_reports/#{File.basename(@report.report_path)}")
    end

    def total_active_registrations
      WasteExemptionsEngine::Registration
        .joins(:registration_exemptions)
        .where(registration_exemptions: { state: :active })
        .count
    end
  end
end
