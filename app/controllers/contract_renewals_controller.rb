class ContractRenewalsController < ApplicationController
  before_action :authenticate_user!, only: [:update]
  before_action :user_identification, only: [:update]

  def update
    @subs = Subscription.find_by(id: params[:subscription_id])
    @renewal = ContractRenewal.find_by(subscription_id: params[:subscription_id])

    update_date = @renewal.next_update_date
    next_update = @renewal.get_update_date(@subs, @renewal.next_update_date)

    # @renewalの更新、review、action_planの保存、いずれも成功した際のみレコードが保存される
    ActiveRecord::Base.transaction do
      @renewal.update!(
        renewal_count: @renewal.renewal_count + 1,
        total_price: @renewal.total_price + @subs.price,
        update_date: update_date,
        next_update_date: next_update,
        total_period: @renewal.get_total_period(@subs.contract_date, next_update)
      )
      review = create_review(@subs, update_date)
    # 成功した場合は、マイページに戻り、更新完了を表示
      sub_name = @renewal.subscription.name
      data = { process_ng: false, sub_name: sub_name, look_back_path: edit_user_subscription_review_path(current_user, @subs, review) }
      render json: { data: data }
    end

    # 失敗した場合は、マイページに戻り、エラーを表示
    rescue => e
      # render時に必要なインスタンス変数の用意
      @error = @renewal
      @user = current_user
      @subs = Subscription.where(user_id: @user.id)
      @renewal = []
      @subs.each do |sub|
        @renewal << sub.contract_renewal
      end
      render json: { process_ng: true }
  end

  private

  # ログインユーザーの確認
  def user_identification
    redirect_to user_path(current_user) if current_user != User.find_by(id: params[:user_id])
  end

  def create_review(sub, update_date)
    review = Review.new(
      review_rate: nil,
      review_comment: nil,
      start_date: sub.get_update_cycle_days(update_date),
      end_date: update_date - 1,
      later_check_id: 2,
      subscription_id: sub.id
    )
    review.save!
    ActionPlan.create!(
      action_rate: nil,
      action_review_comment: nil,
      action_plan: nil,
      review_id: review.id
    )
    return review
  end
end
