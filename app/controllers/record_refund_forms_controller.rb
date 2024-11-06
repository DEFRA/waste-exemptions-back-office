# frozen_string_literal: true

class RecordRefundFormsController < ApplicationController
  def index
    find_resource(params[:registration_reference])
    @payments = @resource&.account&.payments.refundable_offline
    #authorize
  end

  def new
    setup_form
    @payment = @resource&.account&.payments&.find_by(id: params[:payment_id])
    unless @payment
      redirect_to registration_payment_details_path(registration_reference: @resource.reference)
    end
  end

  def create
    setup_form
    begin
      @payment = WasteExemptionsEngine::Payment.find(record_refund_params[:payment_id])
      if @record_refund_form.submit(record_refund_params)
        flash[:success] = "Refund was successfully recorded"
        redirect_to registration_payment_details_path(registration_reference: @resource.reference)
      else
        flash.now[:error] = "Could not record refund - please check the form for errors"
        render :new
      end
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "Could not find the specified payment"
      redirect_to registration_payment_details_path(registration_reference: @resource.reference)
    end
  end

  private

  def find_resource(reference)
    @resource = WasteExemptionsEngine::Registration.find_by(reference: reference)
  end

  def authorize
    authorize! :read, @resource
  end

  def setup_form
    find_resource(params[:registration_reference])
    @record_refund_form = RecordRefundForm.new
  end

  def record_refund_params
    params.require(:record_refund_form).permit(:reason, :payment_id, :amount)
  end
end
