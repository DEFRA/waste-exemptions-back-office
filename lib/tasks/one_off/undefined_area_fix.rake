# frozen_string_literal: true

namespace :one_off do
  desc "Fix areas for manually added site addresses (see RUBY-3013)"
  task undefined_area_fix: :environment do
    regs = find_registrations_with_undefined_area

    stats = { regs: regs, regs_fixed: [], regs_partcode_fixed: [], regs_not_fixed: [] }

    regs.select do |reg|
      next if reg.site_address.area.present?

      # try to find area by postcode
      area = find_area_by_postcode(reg.site_address.postcode)
      if area.present?
        reg.site_address.update(area: area)
        stats[:regs_fixed].push reg
        next
      end

      # try to find area by postcode without last letter
      partcode = reg.site_address.postcode[0..-2]
      area = find_area_by_postcode(partcode)
      if area.present?
        reg.site_address.update(area: area)
        stats[:regs_partcode_fixed].push reg
        next
      end

      stats[:regs_not_fixed].push reg
    end

    print_stats(stats)
  end
end

def find_registrations_with_undefined_area
  undefined_reg_site_addresses = WasteExemptionsEngine::Address.where(address_type: 3, mode: 2).where(area: nil)
  WasteExemptionsEngine::Registration.where("created_at > ?", 3.years.ago)
                                     .where(id: undefined_reg_site_addresses.pluck(:registration_id))
end

def find_area_by_postcode(postcode)
  coords = WasteExemptionsEngine::DetermineEastingAndNorthingService.run(grid_reference: nil, postcode: postcode)
  if coords.present? && coords[:easting] != 0.0 && coords[:northing] != 0.0
    area = WasteExemptionsEngine::DetermineAreaService.run(easting: coords[:easting], northing: coords[:northing])
    return area
  end
  nil
end

def print_stats(stats)
  return if Rails.env.test?

  puts "Number of regs with undefined EA area: #{stats[:regs].count}"
  puts "Number of regs that can be fixed without data manipulations: #{stats[:regs_fixed].count}"
  puts stats[:regs_fixed].map(&:reference).join(", ")
  puts "Number of regs that can be fixed by matching postcode (excl. last letter): #{stats[:regs_partcode_fixed].count}"
  puts stats[:regs_partcode_fixed].map(&:reference).join(", ")
  puts "Number of regs that can't be fixed: #{stats[:regs_not_fixed].count}"
  puts stats[:regs_not_fixed].map(&:reference).join(", ")
end
