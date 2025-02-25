# frozen_string_literal: true

module CompaniesHouseNameMatching
  class CompareCompanyNames < WasteExemptionsEngine::BaseService
    COMMON_WORDS = %w[LIMITED LTD PLC HOLDINGS SERVICES GROUP INCORPORATED INC AND &].freeze

    def run(companies_house_name:, other_company_name:)
      @companies_house_name = companies_house_name
      return 0.0 if other_company_name.blank? || @companies_house_name.blank?

      normalized_companies_house_name = normalize_company_name(@companies_house_name)
      normalized_other_company_name = normalize_company_name(other_company_name)
      name_similarity(normalized_companies_house_name, normalized_other_company_name)
    end

    private

    def normalize_company_name(name)
      words = name.upcase.gsub(/[^A-Z0-9\s]/, "").split
      words.reject { |word| COMMON_WORDS.include?(word) }.join(" ")
    end

    def name_similarity(name1, name2)
      longer, shorter = [name1, name2].sort_by(&:length)
      distance = levenshtein_distance(longer, shorter)
      1 - (distance.to_f / longer.length)
    end

    # method to calculate the Levenshtein distance between two strings
    # Levenshtein distance is a string metric for measuring the difference between two sequences
    # https://en.wikipedia.org/wiki/Levenshtein_distance

    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Naming/MethodParameterName
    def levenshtein_distance(s, t)
      m = s.length
      n = t.length
      return m if n.zero?
      return n if m.zero?

      d = Array.new(m + 1) { Array.new(n + 1) }

      (0..m).each { |i| d[i][0] = i }
      (0..n).each { |j| d[0][j] = j }
      (1..n).each do |j|
        (1..m).each do |i|
          d[i][j] = if s[i - 1] == t[j - 1]
                      d[i - 1][j - 1]
                    else
                      [d[i - 1][j] + 1,    # deletion
                       d[i][j - 1] + 1,    # insertion
                       d[i - 1][j - 1] + 1].min # substitution
                    end
        end
      end
      d[m][n]
    end
    # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity, Naming/MethodParameterName
  end
end
