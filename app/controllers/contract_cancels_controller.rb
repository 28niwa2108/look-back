class ContractCancelsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :user_identification, only: [:new, :create]

  def new
    set_user
    set_subs
    @contract_cancel = ContractCancel.new
  end

  def create
    @contract_cancel = ContractCancel.new(cancel_params)
    if @contract_cancel.save
      redirect_to user_path(current_user)
    else
      set_user
      set_subs
      render :new
    end
  end

  private

  def user_identification
    redirect_to user_path(current_user) if current_user != User.find_by(id: params[:user_id])
  end

  def cancel_params
    params.require(:contract_cancel).permit(
      :cancel_date, :reason_id, :cancel_comment
    ).merge(subscription_id: params[:subscription_id])
  end

  def set_user
    @user = current_user
  end

  def set_subs
    @subs = Subscription.find_by(id: params[:subscription_id])
  end
end
