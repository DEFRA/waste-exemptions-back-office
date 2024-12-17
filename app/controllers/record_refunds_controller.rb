# frozen_string_literal: true

class RecordRefundsController < ApplicationController
  before_action :authorize

  def index
    find_resource(params[:registration_reference])
    @payments = @resource.account.payments.refundable.map { |payment| PaymentPresenter.new(payment) }
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
      @payment = WasteExemptionsEngine::Payment.find(record_refund_params[:payment_id])
      if @record_refund_form.submit(record_refund_params)
        flash[:success] = I18n.t(".record_refunds.create.success")
        redirect_to registration_payment_details_path(registration_reference: @resource.reference)
      else
        @presenter = PaymentPresenter.new(@payment)
        render :new
      end
    rescue ActiveRecord::RecordNotFound
      flash[:error] = I18n.t(".record_refunds.create.not_found")
      redirect_to registration_payment_details_path(registration_reference: @resource.reference)
    end
  end

  private

  def authorize
    resource = find_resource(params[:registration_reference])
    authorize! :refund_payment, resource
  end

  def find_resource(reference)
    @resource = WasteExemptionsEngine::Registration.find_by(reference: reference)
  end

  def setup_form
    find_resource(params[:registration_reference])
    @record_refund_form = RecordRefundForm.new
  end

  def record_refund_params
    params.require(:record_refund_form).permit(:comments, :payment_id, :amount)
  end
end
