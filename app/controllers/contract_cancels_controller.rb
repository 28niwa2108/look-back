class ContractCancelsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :new, :create]
  before_action :user_identification, only: [:index, :new, :create]
  before_action :set_subs, only: [:new, :create]

  def index
    set_user
    subs = Subscription.where(user_id: params[:user_id])
    @subs = []
    @contract_cancels = []
    subs.each do |sub|
      unless sub.contract_cancel.nil?
        @subs << sub
        @contract_cancels << ContractCancel.find_by(subscription_id: sub.id)
      end
    end
  end

  def new
    set_user
    @contract_cancel = ContractCancel.new
  end

  def create
    @contract_cancel = ContractCancel.new(cancel_params)
    if @contract_cancel.save
      redirect_to user_path(current_user)
    else
      set_user
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
    redirect_to user_path(current_user) if @subs.nil? 
  end
end
