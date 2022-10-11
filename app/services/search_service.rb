# frozen_string_literal: true

class SearchService
  def search(term, model, page)
    return empty_results(page) if term.blank?

    results = class_to_search(model).search_registration_and_relations(term.strip)
    paginate_results(results, page)
  end

  private

  def empty_results(page)
    Kaminari.paginate_array([]).page(page)
  end

  def class_to_search(model)
    return WasteExemptionsEngine::NewRegistration if model == :new_registrations

    WasteExemptionsEngine::Registration
  end

  def paginate_results(results, page)
    return empty_results(page) if results.nil?

    results.page(page)
  end
end
