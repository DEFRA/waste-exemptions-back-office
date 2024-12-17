# frozen_string_literal: true

class RecordReversalsController < ApplicationController
  before_action :authorize

  def index
    find_resource(params[:registration_reference])
    @payments = @resource.account.payments.reverseable.map { |payment| PaymentPresenter.new(payment) }
  end

  def new
    setup_form
    @payment = @resource.account.payments.find_by(id: params[:payment_id])
    @presenter = PaymentPresenter.new(@payment) if @payment
    return if @payment

    redirect_to registration_payment_details_path(registration_reference: @resource.reference)
  end

  def create
    setup_form
    begin
      @payment = WasteExemptionsEngine::Payment.find(record_reversal_params[:payment_id])

      if @record_reversal_form.submit(record_reversal_params)
        flash[:success] = I18n.t(".record_reversals.create.success")
        redirect_to registration_payment_details_path(registration_reference: @resource.reference)
      else
        @presenter = PaymentPresenter.new(@payment)
        render :new
      end
    rescue ActiveRecord::RecordNotFound
      flash[:error] = I18n.t(".record_reversals.create.not_found")
      redirect_to registration_payment_details_path(registration_reference: @resource.reference)
    end
  end

  private

  def authorize
    resource = find_resource(params[:registration_reference])
    authorize! :reverse_payment, resource
  end

  def find_resource(reference)
    @resource = WasteExemptionsEngine::Registration.find_by(reference: reference)
  end

  def setup_form
    find_resource(params[:registration_reference])
    @record_reversal_form = RecordReversalForm.new(user: current_user)
  end

  def record_reversal_params
    params.require(:record_reversal_form).permit(:comments, :payment_id)
  end
end
