class ContractRenewalsController < ApplicationController
  before_action :authenticate_user!, except: [:update]
  before_action :user_identification, except: [:update]

  def update
    @subs = Subscription.find_by(id: params[:subscription_id])
    @renewal = ContractRenewal.find_by(subscription_id: params[:subscription_id])
    if @renewal.update(
      renewal_count: @renewal.renewal_count + 1,
      total_price: @renewal.total_price + @subs.price,
      next_update_date: @renewal.get_update_date(@subs, @renewal.next_update_date),
      total_period: @renewal.get_total_period(@subs.contract_date, @renewal.next_update_date)
    )
      redirect_to user_path(current_user)
    else
      @error = @renewal
      set_user
      @subs = Subscription.where(user_id: @user.id)
      @renewal = []
      @subs.each do |sub|
        @renewal << sub.contract_renewal
      end
      render 'users/show'
    end
  end

  private

  # ログインユーザーの確認
  def user_identification
    redirect_to user_path(current_user) if current_user != User.find_by(id: params[:user_id])
  end

  # Userブジェクトのセット
  def set_user
    @user = current_user
  end
end
