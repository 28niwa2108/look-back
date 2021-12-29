class SubscriptionsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :user_identification, except: [:index]

  def show
    set_user
    set_subs
    set_renewal

    #サブスク評価の平均☆を用意
    sum_rate = 0
    review_count = 0
    @subs.reviews.each do |review|
      if review.review_rate != nil
        sum_rate += review.review_rate
        review_count += 1
      end
    end
    @ave_rate = (sum_rate / review_count).round if review_count != 0
  end

  def new
    set_user
    @subs = Subscription.new
  end

  def create
    # @sub・@renewal、どちらのsaveも成功した際のみレコードが保存される
    ActiveRecord::Base.transaction do
      @subs = Subscription.new(subs_params)
      # 更新タイプが「日」なら、更新日タイプをnilにする
      @subs.update_day_type_id = nil if @subs.update_type_id == 1
      @subs.save!
      # 契約更新テーブルに反映
      first_renewal(@subs.id)
    end
    # @sub・@renewal、どちらのsaveも成功したらマイページに遷移する
    redirect_to user_path(current_user)
    #  @sub・@renewal、いずれかのsaveに失敗すれば、登録ページにrenderされ、エラーメッセージが表示される
    rescue => e
      set_user
      render :new
  end

  def edit
    set_user
    set_subs
  end

  def update
    set_subs
    update_sub = subs_params
    # 更新タイプが「日」なら、更新日タイプをnilにする
    update_sub[:update_day_type_id] = nil if update_sub[:update_type_id] == '1'
    if @subs.update(subs_params)
      render json: { process_ng: false }
    else
      set_user
      render json: { process_ng: true }
    end
  end

  def destroy
    set_subs
    sub_name = @subs.name
    if @subs.destroy
      render json: { subname: sub_name }
    else
      render json: { process_ng: true }
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

  # Subscriptionオブジェクトのセット
  def set_subs
    @subs = Subscription.find_by(id: params[:id])
    redirect_to user_path(current_user) if @subs.nil?
  end

  # ContractRenewalオブジェクトのセット
  def set_renewal
    @renewal = ContractRenewal.find_by(subscription_id: @subs.id)
    redirect_to user_path(current_user) if @renewal.nil?
  end

  # Subscriptionストロングパラメーター
  def subs_params
    params.require(:subscription).permit(
      :name, :price, :contract_date, :update_type_id, :update_cycle, :update_day_type_id
    ).merge(user_id: current_user.id)
  end

  #  サブスク「登録」時、契約更新テーブルにも反映
  def first_renewal(sub_id)
    @subs = Subscription.find_by(id: sub_id)
    @renewal = ContractRenewal.new(
      renewal_count: 0,
      total_price: @subs.price,
      update_date: Date.today,
      subscription_id: @subs.id
    )
    @renewal.next_update_date = @renewal.get_update_date(@subs, @subs.contract_date)
    @renewal.total_period = @renewal.get_total_period(@subs.contract_date, @renewal.next_update_date)
    
    judge = true

    # 次回更新日 >= 今日の日付 になるまで、更新処理を行う
    while judge
      if @renewal.next_update_date >= Date.today
        judge = false
      else
        @renewal.update_date = @renewal.next_update_date
        @renewal.next_update_date = @renewal.get_update_date(@subs, @renewal.next_update_date)
        @renewal.renewal_count += 1
        @renewal.total_price += @subs.price
        @renewal.total_period += @renewal.get_total_period(@renewal.update_date, @renewal.next_update_date)
      end
    end

    @renewal.save!
  end
end
