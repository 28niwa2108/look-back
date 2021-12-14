class ContractRenewalsController < ApplicationController
  before_action :authenticate_user!, only: [:update]
  before_action :user_identification, only: [:update]

  def update
    @subs = Subscription.find_by(id: params[:subscription_id])
    @renewal = ContractRenewal.find_by(subscription_id: params[:subscription_id])

    # total_periodの更新に、「次回」更新日が必要なため、予め変数に代入しておく
    next_update = @renewal.get_update_date(@subs, @renewal.next_update_date)
    if @renewal.update(
      renewal_count: @renewal.renewal_count + 1,
      total_price: @renewal.total_price + @subs.price,
      next_update_date: next_update,
      total_period: @renewal.get_total_period(@subs.contract_date, next_update)
    )
      redirect_to user_path(current_user)
    else
      # render時に必要なインスタンス変数の用意
      @error = @renewal
      @user = current_user
      @subs = Subscription.where(user_id: @user.id)
      @renewal = []
      @subs.each do |sub|
        @renewal << sub.contract_renewal
      end
      # 失敗した場合は、マイページに戻る
      render 'users/show'
    end
  end

  private

  # ログインユーザーの確認
  def user_identification
    redirect_to user_path(current_user) if current_user != User.find_by(id: params[:user_id])
  end

