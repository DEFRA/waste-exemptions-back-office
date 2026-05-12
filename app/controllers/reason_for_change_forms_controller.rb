# frozen_string_literal: true

class ReasonForChangeFormsController < EditFormsBaseController
  def new
    super(ReasonForChangeForm, "reason_for_change_form")
  end

  def create
    super(ReasonForChangeForm, "reason_for_change_form")
  end

  private

  def transient_registration_attributes
    params.fetch(:reason_for_change_form, {}).permit(:reason_for_change)
  end
end
