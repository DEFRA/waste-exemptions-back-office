# frozen_string_literal: true

class CertificatesController < ApplicationController
  include CanRenderPdf

  def show
    find_resource(params[:registration_reference])
    @presenter = WasteExemptionsEngine::CertificatePresenter.new(@resource)
  end

  def pdf
    find_resource(params[:registration_reference])
    @presenter = WasteExemptionsEngine::CertificatePresenter.new(@resource)

    render pdf: @resource.reference,
           show_as_html: show_as_html?,
           layout: false,
           page_size: "A4",
           margin: { top: "10mm", bottom: "10mm", left: "10mm", right: "10mm" },
           print_media_type: true,
           template: "waste_exemptions_engine/pdfs/certificate"
  end

  def find_resource(reference)
    @resource = WasteExemptionsEngine::Registration.find_by(reference: reference)
  end

  def authorize
    authorize! :read, @resource
  end

  def show_as_html?
    params[:show_as_html] == "true"
  end
end
