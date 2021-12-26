class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:all_index, :index, :edit, :update]
  before_action :user_identification, only: [:all_index, :index, :edit, :update]

  def all_index
  end

  def index
  end

  def edit
    set_user
    set_subs
    set_review
    @action = ActionPlan.find_by(review_id: params[:id])
    @review_action = ReviewAction.new(
      review_rate: @review.review_rate,
      review_comment: @review.review_comment,
      start_date: @review.start_date,
      end_date: @review.end_date,
      later_check_id: @review.later_check_id,
      subscription_id: @review.subscription_id,
      action_rate: @action.action_rate,
      action_review_comment: @action.action_review_comment,
      action_plan: @action.action_plan,
      review_id: @action.review_id
    )
  end

  def update
    @review_action = ReviewAction.new(review_params)
    ActiveRecord::Base.transaction do
      @review_action.valid?
      @review_action.save
    end
      redirect_to user_subscription_reviews_path(current_user, params[:subscription_id])
    rescue => e
      set_user
      set_subs
      set_review
      render :edit
  end

  private

  # ログインユーザーの確認
  def user_identification
    redirect_to user_path(current_user) if current_user != User.find_by(id: params[:user_id])
  end

  # ReviewActionストロングパラメーター
  def review_params
    params.require(:review_action).permit(
      :review_rate, :review_comment, :start_date, :end_date, :later_check_id,
      :action_rate, :action_review_comment, :action_plan, :review_id
    ).merge(subscription_id: params[:subscription_id], review_id: params[:id])
  end

  # Userブジェクトのセット
  def set_user
    @user = current_user
  end

  # Subscriptionオブジェクトのセット
  def set_subs
    @subs = Subscription.find_by(id: params[:subscription_id])
    redirect_to user_path(current_user) if @subs.nil?
  end

  def set_review
    @review = Review.find_by(id: params[:id])
    redirect_to user_path(current_user) if @review.nil?
  end
end
