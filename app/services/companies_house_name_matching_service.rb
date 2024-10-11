require 'defra_ruby_companies_house'

class CompaniesHouseNameMatchingService < WasteExemptionsEngine::BaseService
  SIMILARITY_THRESHOLD = 0.7
  COMMON_WORDS = %w(LIMITED LTD PLC HOLDINGS SERVICES GROUP INCORPORATED INC).freeze
  RATE_LIMIT = 600
  TIME_WINDOW = 300 # 5 minutes in seconds
  RATE_LIMIT_BUFFER = 0.75 # Use only 75% of the rate limit

  def initialize(dry_run: true)
    @request_count = 0
    @max_requests = (RATE_LIMIT * RATE_LIMIT_BUFFER).to_i
    @unproposed_changes = {}
    @dry_run = dry_run
  end

  def run
    active_registrations = fetch_active_registrations
    grouped_registrations = group_registrations(active_registrations)
    proposed_changes = identify_name_changes(grouped_registrations)

    if @dry_run
      print_summary(proposed_changes)
      print_unproposed_changes
    else
      apply_changes(proposed_changes)
      print_summary(proposed_changes, applied: true)
    end

    proposed_changes
  end

  private

  def fetch_active_registrations
    WasteExemptionsEngine::Registration.joins(:registration_exemptions)
                                       .where(registration_exemptions: { state: :active })
                                       .where.not(operator_name: nil, company_no: [nil, ''])
                                       .distinct
  end

  def group_registrations(registrations)
    registrations.group_by(&:company_no)
  end

  def identify_name_changes(grouped_registrations)
    proposed_changes = {}

    puts "Total number of company numbers to process: #{grouped_registrations.size}"

    sorted_grouped_registrations = grouped_registrations.sort_by { |_, group| -group.size }.first(@max_requests)

    sorted_grouped_registrations.each do |company_no, registrations|
      companies_house_name = fetch_companies_house_name(company_no)
      next unless companies_house_name

      normalized_ch_name = normalize_company_name(companies_house_name)

      changes = registrations.map do |registration|
        normalized_reg_name = normalize_company_name(registration.operator_name)
        similarity = name_similarity(normalized_ch_name, normalized_reg_name)
        if similarity >= SIMILARITY_THRESHOLD && companies_house_name != registration.operator_name
          [registration.id, registration.operator_name, companies_house_name]
        else
          @unproposed_changes[company_no] ||= []
          @unproposed_changes[company_no] << {
            registration_id: registration.id,
            current_name: registration.operator_name,
            companies_house_name: companies_house_name,
            similarity: similarity
          }
          nil
        end
      end.compact

      proposed_changes[company_no] = changes if changes.any?
    end

    proposed_changes
  end

  def apply_changes(proposed_changes)
    ActiveRecord::Base.transaction do
      proposed_changes.each do |company_no, changes|
        changes.each do |id, old_name, new_name|
          registration = WasteExemptionsEngine::Registration.find(id)
          registration.update!(operator_name: new_name)
        end
      end
    end
  end

  def normalize_company_name(name)
    words = name.upcase.gsub(/[^A-Z0-9\s]/, '').split
    words.reject { |word| COMMON_WORDS.include?(word) }.join(' ')
  end

  def name_similarity(name1, name2)
    longer, shorter = [name1, name2].sort_by(&:length)
    distance = levenshtein_distance(longer, shorter)
    1 - (distance.to_f / longer.length)
  end

  # method to calculate the Levenshtein distance between two strings
  # Levenshtein distance is a string metric for measuring the difference between two sequences
  # https://en.wikipedia.org/wiki/Levenshtein_distance
  def levenshtein_distance(s, t)
    m = s.length
    n = t.length
    return m if n == 0
    return n if m == 0
    d = Array.new(m+1) {Array.new(n+1)}

    (0..m).each {|i| d[i][0] = i}
    (0..n).each {|j| d[0][j] = j}
    (1..n).each do |j|
      (1..m).each do |i|
        d[i][j] = if s[i-1] == t[j-1]
                    d[i-1][j-1]
                  else
                    [d[i-1][j]+1,    # deletion
                     d[i][j-1]+1,    # insertion
                     d[i-1][j-1]+1,  # substitution
                    ].min
                  end
      end
    end
    d[m][n]
  end

  def fetch_companies_house_name(company_no)
    return nil if @request_count >= @max_requests

    @request_count += 1
    client = DefraRubyCompaniesHouse.new(company_no)
    client.company_name
  rescue StandardError => e
    Rails.logger.error("Failed to fetch company name for #{company_no}: #{e.message}")
    nil
  end

  def print_summary(proposed_changes, applied: false)
    action = applied ? "applied" : "proposed"
    puts "Total number of company numbers processed: #{@request_count}"
    puts "Total number of company numbers with #{action} name changes: #{proposed_changes.size}"
    puts "\n#{action.capitalize} name changes:"
    if proposed_changes.empty?
      puts "  No changes #{action}."
    else
      proposed_changes.each do |company_no, changes|
        puts "  Company number: #{company_no}"
        changes.each do |id, old_name, new_name|
          puts "    Registration ID: #{id}, Old name: '#{old_name}', New name: '#{new_name}'"
        end
      end
    end
  end

  def print_unproposed_changes
    puts "\nCompany numbers for which changes were not proposed:"
    if @unproposed_changes.empty?
      puts "  No unproposed changes."
    else
      @unproposed_changes.each do |company_no, details|
        puts "  Company number: #{company_no}"
        details.each do |detail|
          puts "    Registration ID: #{detail[:registration_id]}"
          puts "    Current name: '#{detail[:current_name]}'"
          puts "    Companies House name: '#{detail[:companies_house_name]}'"
          puts "    Name similarity: #{detail[:similarity].round(2)}"
          puts ""
        end
      end
    end
  end
end
