# frozen_string_literal: true

class SearchService
  # Preloaded so rendering each result's status does not query its exemptions,
  # account, orders and payments one result at a time.
  SEARCH_RESULT_ASSOCIATIONS = [
    :registration_exemptions,
    { account: [:payments, :charge_adjustments, { orders: :charge_detail }] }
  ].freeze

  def search(term, model, page)
    return empty_results(page) if term.blank?

    model_class = class_to_search(model)
    results = model_class.search_registration_and_relations(term.strip)
    paginate_results(preload_search_result_associations(results, model_class), page)
  end

  private

  def preload_search_result_associations(results, model_class)
    return results if results.nil? || model_class != WasteExemptionsEngine::Registration

    results.preload(SEARCH_RESULT_ASSOCIATIONS)
  end

  def empty_results(page)
    Kaminari.paginate_array([]).page(page)
  end

  def class_to_search(model)
    return WasteExemptionsEngine::TransientRegistration if model == :new_registrations

    WasteExemptionsEngine::Registration
  end

  def paginate_results(results, page)
    return empty_results(page) if results.nil?

    results.page(page)
  end
end
